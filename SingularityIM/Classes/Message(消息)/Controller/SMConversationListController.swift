//
//  ConversationListController.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit
import IMSingularity_Swift
import MJRefresh
import FMDB
import SDWebImage
import ODRefreshControl
import MBProgressHUD

/** 会话列表控制器 */
class SMConversationListController: UITableViewController {
    
    // MARK: 懒加载
    var hud: MBProgressHUD!
    
    var searchController: UISearchController!
    
    // 计时器
    private var timer: NSTimer!
    
    /**
     *  @brief  下拉刷新控件
     */
    var mRefreshControl: ODRefreshControl!
    
    // 数据操作实例
    lazy var dataUtil: DataUtil = {
        return DataUtil.sharedInstance()
    }()
    
    /** 数据库工具实例 */
    lazy var dbUtil: DBUtil = {
        
       return DBUtil.sharedInstance
        
    }()
    
    // 通知对象实例
    lazy var notification: NSNotificationCenter = {
        
        return NSNotificationCenter.defaultCenter()
        
    }()
    
    // 会话列表数据
    lazy var sessionList: Array<IMSession> = {
        return Array()
    }()
    
    /** 数据库文件的路径 */
    var path: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        // 创建UI
        self.initUI()
        
        // 保持心跳
        // 定义一个计时器 每隔一分钟执行心跳方法
        self.timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(self.heart), userInfo: nil, repeats: true)
        
        // 执行计时器
        self.timer.fire()
    }
    
    // MARK: 注册通知
    /** 注册通知 */
    override func viewDidAppear(animated: Bool) {
        
        // 初始化数据
        self.initData()

        // 先移除所有通知
        self.notification.removeObserver(self)
        
        // 注册获取会话列表的通知
        notification.addObserver(self, selector: #selector(self.getChatSessionList(_:)), name: "chatSessionListUpdateNotification", object: nil)
        
        // 注册收到新消息的通知
        notification.addObserver(self, selector: #selector(self.receiveNewMessage(_:)), name: "receiveMessageNotification", object: nil)
        
        // 注册发送消息成功的通知
        notification.addObserver(self, selector: #selector(self.messageCallback(_:)), name: "messageSendSuccessNotification", object: nil)
        
        // 重新刷新页面
        self.tableView.reloadData()
    }
    
    
    /** 创建UI */
    private func initUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "消息"
        
        self.definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: SMSearchViewController())
        
        searchController.searchBar.placeholder = "搜索"
        
        searchController.searchBar.searchBarStyle = .Minimal
        
        searchController.searchBar.backgroundColor = UIColor(patternImage: UIImage(named: "timeline_retweet_background")!)
        
        searchController.searchBar.barTintColor = UIColor.greenColor()
        
        searchController.delegate = self
        
        // 设置为false,可以点击搜索出来的内容 setSearchFieldBackgroundImage
        searchController.dimsBackgroundDuringPresentation = true
        
//        searchController.sea = self
        
        searchController.definesPresentationContext = true
        
        self.mRefreshControl = ODRefreshControl(inScrollView: self.tableView!)
        
        self.mRefreshControl.addTarget(self, action: #selector(self.loadNewData), forControlEvents: .ValueChanged)
        
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.registerClass(SessionCell.self, forCellReuseIdentifier: "sessionCell")
        
        // 取消分割线样式
        self.tableView.separatorStyle = .None
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.rowHeight = 70
        
    }
    
    
    /** 初始化数据 */
    private func initData() {
        
        self.tableView.dataSource = self
        
        self.tableView.delegate = self
        
        NSLog("今天星期\(NSDate().dayOfWeek())")
        
        // 首先从数据库读取会话列表数据
        let sessionList: Array<IMSession> = self.dbUtil.querySessions("SELECT * FROM t_sessionList;")
        
        if(sessionList.count == 0) {
            
            NSLog("本地没有数据--网络获取")
            
//            self.tableView.mj_header.beginRefreshing()
            self.mRefreshControl.endRefreshing()
            
        }else {
            
            self.sessionList = sessionList
            
            NSLog("本地有数据--数据库获取")
            
            // 刷新会话列表数据
            self.refreshSessionList()
        }
    }
    
    
    /** 网络加载新数据 */
    @objc private func loadNewData() {
        
        self.dataUtil.getChatSessionList()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: 监听事件处理
extension SMConversationListController {
    
    /** 保持心跳 */
    @objc private func heart() {
        self.dataUtil.saveOnlineState()
    }
    
    /** 刷新列表数据 */
    private func refreshSessionList() {
        self.tableView.reloadData()
    }
    
}

// MARK: 通知回调方法
extension SMConversationListController {
    
    /** 获取会话列表的通知回调方法 */
    func getChatSessionList(notification: NSNotification) {
        self.sessionList = notification.userInfo!["list"] as! Array<IMSession>
        print("得到数据条数: \(self.sessionList.count)")
        
        // 将网络数据存储到数据库
        self.dbUtil.insertToSessionTable(self.sessionList)
        
        // 刷新列表
        self.refreshSessionList()
        
        // 收起刷新状态
        self.mRefreshControl.endRefreshing()
    }
    
    /** 收到消息的通知回调方法 */
    @objc private func receiveNewMessage(notification: NSNotification) {
//        let mess = notification.userInfo!["message"] as! Message
        self.loadNewData()
    }
    
    /** 发送消息成功的通知回调 */
    @objc private func messageCallback(notification: NSNotification) {
//        let mes = notification.userInfo!["message"] as! Message
        // 处理
        self.loadNewData()
    }
    
}


// MARK: UITableViewDataSource, UITableViewDelegate 协议方法

extension SMConversationListController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sessionList.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "sessionCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath:
            indexPath) as! SessionCell
        
        cell.session = self.sessionList[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 取消选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        // 传递数据
        let chatVc = SMChatViewController()
        
        let chatId = self.sessionList[indexPath.row].chat_session_id!
        
        chatVc.chat_session_id = chatId
        
        chatVc.targetId = self.sessionList[indexPath.row].target_id
        
        var name = self.sessionList[indexPath.row].target_name
        
        if(name == nil) {
            
            name = "用户名"
            
        }
        
        chatVc.targetName = name
        
        chatVc.targetState = self.sessionList[indexPath.row].target_online_status
        
        chatVc.lastUnreadMessageId = self.sessionList[indexPath.row].last_message_id
        
        // 修改未读标签
        self.sessionList[indexPath.row].message_count = "0"
        
        // 更改数据库数据
        
        // 确认未读消息
        self.dataUtil.confirmMessage(self.sessionList[indexPath.row].last_message_id!, chatSessionID: chatId)
        
        // 跳转页面
        
        self.navigationController?.pushViewController(chatVc, animated: true)
        
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let top = UITableViewRowAction(style: .Normal, title: "消息置顶") { (action, indexPath) -> Void in
            
            let session = self.sessionList[indexPath.row]
            
            self.sessionList.removeAtIndex(indexPath.row)
            
            self.sessionList.insert(session, atIndex: 0)
            
//            let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionCell
//
//            cell.backgroundColor = UIColor.lightGrayColor()
            
            self.tableView.reloadData()

        }
        
        top.backgroundColor = UIColor.lightGrayColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "删除") { (action, indexPath) -> Void in

            self.sessionList.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, top]
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        }else {
            
        }
    }
}


// MARK: UISearchControllerDelegate 协议方法
extension SMConversationListController: UISearchControllerDelegate {
    
    func willPresentSearchController(searchController: UISearchController) {
        
        NSLog("willPresentSearchController")
        
    }
    
}