//
//  ChatableViewiewController.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/28.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

import Qiniu
import MJRefresh
import MBProgressHUD
import IMSingularity_Swift

/** 聊天会话窗口 */
class SMChatViewController: UIViewController {
    
    // 信息分页页码
    var pageNum = 0
    
    // 标记
    var flag = true
    
    // 记录已查看信息的高度
    var readMessageHeight: CGFloat = 0
    
    // 是否正在切换键盘
    var isChangingKeyboard: Bool = false
    
    /** 未读的最后一条消息id */
    var lastUnreadMessageId: String?
    
    /** 会话id */
    var chat_session_id = ""
    
    /** 是否从本地数据库获取消息 - 默认为true */
    var dataFromDB = true
    
    /** 会话对象信息 */
    var targetName: String!
    
    var targetId: String!
    
    var targetState: String!
    
    // 子视图
    var headView: ChatHeadView!
    
    var inputToolbar: SMComposeToolbar!
    
    // 数据库操作实体
    var dbUtil: DBUtil = DBUtil.sharedInstance
    
    // 数据操作实例
    lazy var dataUtil: DataUtil = {
        
        return DataUtil.sharedInstance()
        
    }()
    
    // 通知对象实例
    lazy var notification: NSNotificationCenter = {
        
        return NSNotificationCenter.defaultCenter()
        
    }()
    
    /** 消息数据(存放着所有的消息和frame) */
    var messagesFrames: NSMutableArray = NSMutableArray()
    
    var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 准备UI
        self.prepareUI()
        
        // 初始化数据
        self.initData()
        
    }
    
    
    // 注册通知
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(true)
        
        NSLog("显示")
        
        // 注册获取历史消息的通知
        notification.addObserver(self, selector: #selector(self.getHistoryMessageList(_:)), name: "historyMessageListUpdateNotification", object: nil)
        
        // 发送消息回调的通知
        notification.addObserver(self, selector: #selector(self.messageCallback(_:)), name: "messageSendSuccessNotification", object: nil)
        
        // 收到消息回调的通知
        notification.addObserver(self, selector: #selector(self.receiveNewMessage(_:)), name: "receiveMessageNotification", object: nil)
        
        // 键盘通知
        notification.addObserver(self, selector: #selector(self.keyBoardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(self.keyBoardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.autoScrollToTableBottom(true)
    }
    
    /**
     *	@brief	初始化UI
     *
     *	@return	nil
     */
    private func prepareUI() {
        
        // 设置导航条内容
        self.setupNavBar()
        
        // 添加消息显示列表
        self.setupTableView()
        
        // 添加输入工具条
        self.setupToolbar()
    
    }
    
    
    /**
     *	@brief	设置导航条内容
     *
     *	@return	nil
     */
    private func setupNavBar() {

        self.headView = ChatHeadView()
        
        headView.name = self.targetName
        
        self.setTargetState()
        
        self.navigationItem.titleView = headView
        
        let rightBarView = UIBarButtonItem.itemWithChatRightBar("call_Icon", leftTarget: self, leftAction: nil, rightImageName: "message_Icon", rightTarget: self, rightAction: nil)
        
        self.navigationItem.rightBarButtonItem = rightBarView
        
    }
    
    
    /**
     *	@brief	添加显示列表
     *
     *	@return	nil
     */
    private func setupTableView() {

        self.navigationController?.navigationBar.translucent = false
        
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: SMScreenW, height: SMScreenH - 50 - SMNavigationBarH))
        
        table.registerClass(SMChatTextTableViewCell.self, forCellReuseIdentifier: "SMMessageCell_text_0")
        
        table.registerClass(SMChatTextTableViewCell.self, forCellReuseIdentifier: "SMMessageCell_text_1")
        
        table.registerClass(SMChatImageTableViewCell.self, forCellReuseIdentifier: "SMMessageCell_image_0")
        
        table.registerClass(SMChatImageTableViewCell.self, forCellReuseIdentifier: "SMMessageCell_image_1")
        
        table.registerClass(SMChatVoiceTableViewCell.self, forCellReuseIdentifier: "SMMessageCell_voice_0")
        
        table.registerClass(SMChatVoiceTableViewCell.self, forCellReuseIdentifier: "SMMessageCell_voice_1")
        
        table.registerClass(SMChatTimeTableViewCell.self, forCellReuseIdentifier: "SMMessageCell_time")
        
        table.keyboardDismissMode = .OnDrag
        
        table.delegate = self
        
        table.dataSource = self
        
        table.separatorStyle = .None
        
//        table.backgroundColor = TableBgColor
        table.backgroundColor = kBkColorTableView
        
        self.tableView = table
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.loadMoreMessage))
        
        self.view.addSubview(self.tableView)
    }
    
    
    /**
     *	@brief	添加输入工具条
     *
     *	@return	nil
     */
    private func setupToolbar() {

        let toolbar = SMComposeToolbar(frame: CGRect(x: 0, y: self.view.height - 50 - SMNavigationBarH, width: self.view.width, height: 50))
        
        self.inputToolbar = toolbar
        
        self.inputToolbar.delegate = self
        
        self.view.addSubview(self.inputToolbar)
    }
    
    
    /**
     *	@brief	初始化数据
     *
     *	@return	nil
     */
    private func initData() {

        // 由于未读消息的问题！！！！
        // 还要根据是否有未读消息处理数据
        // 如果有未读消息要先将未读消息存入数据库然后在拉去数据
        
        self.loadMoreMessage()
        
    }
    

    /**
     *	@brief	加载消息数据
     *
     *	@return	nil
     */
    @objc private func loadMoreMessage() {
        
        self.readMessageHeight = self.tableView.contentSize.height
        
        if(self.dataFromDB) {
            
            loadMessageFromDB()     // 本地数据库获取
            
        }else {
            
            loadMessageFromNetWork()     // 网络获取
            
        }
    }
    
    
    /**
     *	@brief	从本地数据库拉取数据
     *
     */
    private func loadMessageFromDB() {
        
        // 按照时间顺序查询
        let sql = "SELECT * FROM t_messageList WHERE chat_session_id = '\(self.chat_session_id)' ORDER BY message_time DESC limit '\(self.pageNum * 5)', 5;"
        
        NSLog("sql语句: \(sql)")
        
        let messageArray: Array<Message> = self.dbUtil.queryMessages(sql)
        
        if(messageArray.count == 0) {
            
            self.dataFromDB = false
            
            // 从网络拉取数据
            self.loadMessageFromNetWork()
            
        }else {
            
            let messageFrames: NSMutableArray = self.messageFramesWithMessages(messageArray)
            
            let range = NSMakeRange(0, messageFrames.count)
            
            let indexSet = NSIndexSet(indexesInRange: range)
            
            self.messagesFrames.insertObjects(messageFrames as [AnyObject], atIndexes: indexSet)
            
            self.pageNum += 1
            
            self.tableView.reloadData()
            
            self.autoScrollToscanPostistion(false)
            
            self.tableView.mj_header.endRefreshing()
            
        }

    }
    
    
    /**
     *	@brief	从网络拉取数据
     *
     *	@return	nil
     */
    private func loadMessageFromNetWork() {

        dispatch_sync(dispatch_get_global_queue(0, 0)) {
            
            if(self.messagesFrames.count == 0) {
                
                self.dataUtil.getHistoryMessages(self.chat_session_id, size: "5")
                
            }else {
                
                self.dataUtil.getHistoryMessagesBeforeMessageID(self.chat_session_id, size: "5", beforeMessageID: (self.messagesFrames[0] as! SMMessageFrame).message.message_id!)
                
            }
        }
    }
    
    
    /**
     *	@brief	将网络数据存储到本地
     *
     *	@param 	Array<Message> 	消息数据
     *
     *	@return	nil
     */
    private func saveDataFromNetWork(array: Array<Message>) {

        
        self.dbUtil.insertTomessageTable(array)
        
    }
    
    
    /** 改变目标状态 */
    private func setTargetState() {
        
        switch self.targetState {
            
        case "0":
            self.headView.stateTitle = "离线"
            
        case "1":
            self.headView.stateTitle = "在线"
            
        default:
            break
        }
        
    }
    
    
    /**
     *	@brief	根据消息创建frame实例
     *
     *	@param 	NSArray 	消息数组
     *
     *	@return
     */
    private func messageFramesWithMessages(messages: NSArray) -> NSMutableArray {
        
        let frames = NSMutableArray()
        
        for mes in messages {
            
            let frame = SMMessageFrame()
            
            //  传递消息模型数据，计算所有子控件的frame
            frame.message = mes as! Message
            
            frames.addObject(frame)
            
        }
        
        return frames
    }
    
    
    /** 新增消息数据 */
    private func addMessageFrame(message: Message) {
        
        let frame = SMMessageFrame()
        
        //  传递消息模型数据，计算所有子控件的frame
        frame.message = message
        
        self.messagesFrames.addObject(frame)
        
        self.tableView.reloadData()
        
        // 存入数据库
        self.saveDataFromNetWork([message])
        
        self.autoScrollToTableBottom(true)
    }
    
    
    /** table自动滚动到顶部 */
    private func autoScrollToTableTop(bool: Bool) {
        
         dispatch_sync(dispatch_get_global_queue(0, 0)) {
            
            if(self.tableView.contentSize.height > self.tableView.bounds.size.height) {
            
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: bool)
            }
        }
        
    }
    
    
    /** table自动滚动到上次浏览位置 */
    private func autoScrollToscanPostistion(bool: Bool) {
        
         dispatch_sync(dispatch_get_global_queue(0, 0)) {
            
            if(self.tableView.contentSize.height > self.tableView.bounds.size.height) {
            
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - self.readMessageHeight - 50), animated: bool)
            
            }
        }
    }

    
    /** table自动滚动到底部 */
    private func autoScrollToTableBottom(bool: Bool) {
        
        dispatch_sync(dispatch_get_global_queue(0, 0)) {
            
            if(self.tableView.contentSize.height > self.tableView.bounds.size.height) {
                
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height), animated: bool)
                
            }
        }
        
    }

    
    /** 删除注册的通知 */
    override func viewDidDisappear(animated: Bool) {
        
        self.notification.removeObserver(self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: 通知回调方法
extension SMChatViewController {
    
    /** 发送消息成功的通知回调 */
     @objc private func messageCallback(notification: NSNotification) {
        
        let mes = notification.userInfo!["message"] as! Message
        
        print("消息\(mes.message)发送回来了")
        
        self.addMessageFrame(mes)
    }
    
    
    /** 收到消息的通知回调方法 */
    @objc private func receiveNewMessage(notification: NSNotification) {
        
        let mess = notification.userInfo!["message"] as! Message
        
        print("消息\(mess.message)来了")
        
        self.addMessageFrame(mess)
    }

    
    /** 获取历史消息通知的回调方法 */
    @objc private func getHistoryMessageList(notification: NSNotification) {
        
        let historyMessages = (notification.userInfo!["list"] as! HistoryMessages).history_messages
        
        let historyFrames: NSMutableArray = self.messageFramesWithMessages(historyMessages)
        
        let range = NSMakeRange(0, historyFrames.count)
        
        let indexSet = NSIndexSet(indexesInRange: range)
        
        NSLog("历史消息 \(historyMessages.count)")
        
        self.messagesFrames.insertObjects(historyFrames as [AnyObject], atIndexes: indexSet)
        
        let unreadMessages = (notification.userInfo!["list"] as! HistoryMessages).unread_messages
        
        let unreadFrames: NSMutableArray = self.messageFramesWithMessages(unreadMessages)
        
        NSLog("未读消息 \(unreadMessages.count)")
        
        self.messagesFrames.addObjectsFromArray(unreadFrames as [AnyObject])
        
        if(historyMessages.count == 0 && unreadMessages.count == 0) {
            
            self.tableView.mj_header.removeFromSuperview()
            
            self.flag = false
            
        }else {
        
            // 存入数据库
            self.dbUtil.insertTomessageTable(unreadMessages)
        
            self.dbUtil.insertTomessageTable(historyMessages)
            
            self.tableView.reloadData()
            
            self.autoScrollToscanPostistion(false)
        }
        
        self.tableView.mj_header.endRefreshing()

    }
    
    
    /** 展开键盘 */
    @objc private func keyBoardWillShow(note: NSNotification) {
        
        // 1.键盘弹出需要的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        // 取出键盘高度
        let keyboardF = note.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
        
        let keyBoardH = keyboardF.height
        
        // 2.动画
        UIView.animateWithDuration(duration) {
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -keyBoardH)
            
            self.inputToolbar.transform = CGAffineTransformMakeTranslation(0, -keyBoardH)
            
//            self.scrollToPoint(CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height + keyBoardH), bool: true)
        }
    }
    
    
    /** 隐藏键盘 */
    @objc private func keyBoardWillHide(note: NSNotification) {
        
        if(self.inputToolbar.changingKeyboard == true) {
            
            return
            
        }
        
        // 1. 键盘弹出需要的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        // 2. 动画
        UIView.animateWithDuration(duration) {
            
            self.tableView.transform = CGAffineTransformIdentity
            
            self.inputToolbar.transform = CGAffineTransformIdentity
            
        }
    }
    
    
    /**
     *	@brief	根据类型和消息来源得到重用id
     *
     *	@param 	Bool 	消息来源
     *	@param 	String 	消息类型
     *
     *	@return	id
     */
    private func kCellReuseIDWithSenderAndType(isSender: Bool, chatCellType: String) -> String {

        
        var sender = "0"
        
        if(isSender == true) {
            
            sender = "0"
            
        }else {
            
            sender = "1"
            
        }
        
        let cellReuseID = "SMMessageCell_\(chatCellType)_\(sender)"
        
        return cellReuseID
    }
    
    
    /**
     *	@brief	根据模型得到类型
     *
     *	@param 	Message
     *
     *	@return	类型字符串
     */
    private func cellTypeWithModel(model: Message) -> String {

        var type = ""
        
        switch model.message_type! {
            
        case "0":
            
            type = "text"
            
        case "1":
            
            type = "image"
            
        case "2":
            
            type = "voice"
            
        default:
            
             type = "text"
            
        }

        return type
    }
    
    
    /**
     *	@brief	设置消息来源
     *
     *	@param 	SMChatBaseTableViewCell 	单元格
     *	@param 	Message 	消息模型
     *
     *	@return
     */
    private func setIsSender(model: Message) -> Bool {

        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        
        let isSender = (userId == model.sender_id) ? true : false
        
        return isSender
    }
    
}


// MARK: UITableViewDelegate, UITableViewDataSource 协议代理方法

extension SMChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.messagesFrames.count
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model = (self.messagesFrames[indexPath.row] as! SMMessageFrame).message
        
        let reuseId = kCellReuseIDWithSenderAndType(setIsSender(model), chatCellType: cellTypeWithModel(model))
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseId) as? SMChatBaseTableViewCell
        
        if(cell == nil) {
            
            cell = SMChatBaseTableViewCell(style: .Default, reuseIdentifier: reuseId)
            
        }
        
        cell?.controller = self
        
        cell!.set_Model((self.messagesFrames[indexPath.row] as! SMMessageFrame))
        
        let _cell = self.configureCell(cell!, atIndexPath: indexPath)
        
        // 取消选中样式
        _cell.selectionStyle = .None
        
        return _cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.view.endEditing(true)
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let mesFrame = self.messagesFrames[indexPath.row] as! SMMessageFrame
        
        return mesFrame.frame.maxY
    }
    
    
    private func configureCell(cell: SMChatBaseTableViewCell, atIndexPath: NSIndexPath) -> SMChatBaseTableViewCell {
        
        let model = (self.messagesFrames[atIndexPath.row] as! SMMessageFrame)
        
        cell.set_Model(model)
        
        return cell
    }
    
    
    /** 当用户开始拖拽scrollView时调用 */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.view.endEditing(true)
        
    }
    
    /** 监听滑动到顶部 */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let point = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)
        
        if(point == CGPointZero) {
            
            NSLog("顶部")
            if(self.flag) { // 如果没有数据了  下拉刷新控件被删除
                
                self.tableView.mj_header.beginRefreshing()
                
            }
        }
        
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate 
extension SMChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 获取token
//        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
//        
//        // 从媒体信息这个字典数据中查询原始图像字典
//        NSLog("info: \(info)")
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        let path = info[UIImagePickerControllerReferenceURL] as? String
//        let upManager = QNUploadManager()
//        // 压缩图片质量
//        let imageData = UIImageJPEGRepresentation(image!, 0.5)
//        
//        upManager.putFile(path, key: nil, token: token, complete: { (info, key, resp) in
//            NSLog("resp: \(resp)")
//            let content = resp["url"] as! String
//            }, option: nil)
//        upManager.put
//        let data = imageData!.base64EncodedDataWithOptions(.Encoding64CharacterLineLength)
////        let data: NSData = NSData(contentsOfFile: dataString as String)!
//        
//        let dataString: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
//        let str: String = String(dataString)
//        upManager.putData(NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.rawValue), key: nil, token: token, complete: { (info, key, resp) in
//           
//            let content = resp["url"] as! String
//            
//            // 将图片地址发送到服务器
//            self.dataUtil.sendMessage(self.targetId, content: "\(content)", messageToken: NSDate.dateToTimeStamp(NSDate()), messageType: "1")
//            }, option: nil)
//        self.dismissViewControllerAnimated(true) { 
//            NSLog("直接选择")
//        }
    }
}

// MARK: InputableViewiewDelegate协议方法
//extension SMChatViewController: InputViewDelegate {
//    /** 发送消息 */
//    func sendBtnClick(text: String) {
//        print("发送： \(text)")
//        self.dataUtil.sendMessage(self.targetId, content: text, messageToken: NSDate.dateToTimeStamp(NSDate()), messageType: "0")
//    }
//    
//    /** 相册 */
//    func photoBtnClick() {
//        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.allowsEditing = false// 选择照片之后不允许编辑
//            imagePicker.sourceType = .PhotoLibrary
//            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//    }
//}


// MARK: SMComposeToolbarDelegate 代理协议
extension SMChatViewController: SMComposeToolbarDelegate {
    
    func composeToolDidClickedButton(toolbar: SMComposeToolbar, buttonType: Int) {
        
        switch buttonType {
            
        case SMComposeToolBarButtonType.Voice.rawValue:
            NSLog("点击语音")
//            toolbar.showVoiceButton = !toolbar.showVoiceButton
            
        case SMComposeToolBarButtonType.Emotion.rawValue:
            NSLog("点击表情")
//            toolbar.showEmojiButton = !toolbar.showEmojiButton
            
        case SMComposeToolBarButtonType.Add.rawValue:
            NSLog("点击添加")
            
        default:
            break
        }
        
    }
    
    
    /**
     *	@brief	发送消息
     *
     *	@param 	String 	消息文本
     *
     */
    func sendMessage(text: String) {

        print("发送： \(text)")
        self.dataUtil.sendMessage(self.targetId, content: text, messageToken: NSDate.dateToTimeStamp(NSDate()), messageType: "0")
    }
    
}
