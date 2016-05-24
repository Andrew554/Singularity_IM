//
//  DataProcess.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import Foundation
import Alamofire
import IMSingularity_Swift

// 数据处理类
class DataUtil: NSObject {
    
    // 自己的实例（鉴于只会创建一个实例，避免多次创建消耗内存，采用单例模式）
    // 单例的第一种方式 直接创建一个实例返回
/**
    static let _instance = DataProcess()
    class var sharedInstance: DataProcess {
    return _instance
    }
*/

    // 单例的第二种方式：通过在类方法里面创建一个结构体，里面声明一个静态的实例，接着直接创建实例对象，最后返回这个结构的实例
/**
    class var sharedInstance: DataProcess {
        struct Static {
            static let instance: DataProcess = DataProcess()
        }
        
        return Static.instance
    }
*/
    
    // 单例的第三种方式：通过在类方法里面创建一个结构体，里面声明一个静态的实例，然后在异步线程里创建实例对象，最后返回这个结构的实例 --》 个人比较偏向第三种，用到异步线程
    class func sharedInstance()-> DataUtil {
        // 结构体
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataUtil? = nil
        }
    
        // 异步线程创建实例
        if(Static.instance == nil) {
            dispatch_once(&Static.onceToken) { () -> Void in
                Static.instance = DataUtil()
            }
        }
        
        return Static.instance!
    }

    // SDK实例
    private var singularity: IMSingularity?
    // 通知实例
    private var notification: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    // Token字符串
    private var token: String?
    // 状态
    private var state: Int = 0
    // 数据库
    var dbUtil: DBUtil = DBUtil.sharedInstance
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        super.init()
        // 连接服务器通信
        self.service_init()
    }
    
    // 获取Token
    private func getToken(id: String, name: String, picture: String) {
        print("获取token")
        // 设置参数
        let parameters = [
            "user_id": id,
            "user_name": name,
            "user_picture": picture
        ]
        
        //网络请求
        Alamofire.request(.POST, HttpURL.token, parameters: parameters)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    if let tokenDic = JSON as? NSDictionary {
//                        print("获取：\(tokenDic.valueForKey("data") as? String)")
                        self.token = tokenDic.valueForKey("data") as? String
                        print("得到token \(self.token!)")
                        self.notification.postNotificationName("getToken", object: nil)
                        // 调用登录方法
                        self.singularity!.externalLogin(self.token!)
                    }
                }
        }
    }
    
    
    // 连接服务器通信
    private func service_init() {
        print("连接服务器")
        // 实例化
        self.singularity = IMSingularity()
        
        // 设置代理
        self.singularity!.delegate = self
        
        // 连接
        self.singularity!.initWithConnectionUrl(HttpURL.serviceLink)
    }
    
    // 登录成功存储用户信息
    private func saveUserInfo(info: UserInfo) {
        // 比对登录是否为同一个账号
        let lastId = defaults.objectForKey("id") as? String
        
        if(lastId != nil) {
            
            if(lastId != info.user_id) {
                // 删除本地数据
                self.dbUtil.deleteTable("t_sessionList")
                NSLog("更换账号...")
            }

        }
        
        defaults.setObject(info.upload_token, forKey: "token")
        
        defaults.setObject(info.user_id, forKey: "id")
        defaults.setObject(info.user_name, forKey: "name")
        defaults.setObject(info.user_picture, forKey: "picture")

        // 立即存储，实时更新
        defaults.synchronize()
    }
}


// 扩展：点击事件处理
extension DataUtil {
    
    /** 登录 */
    func invokeLogin(id: String, name: String, picture: String) {
        print("invokeLogin")
        self.token = defaults.objectForKey("token") as? String
        
//        if(self.token == nil) {
            // 获取Token
            self.getToken(id, name: name, picture: picture)
//        }else {
            // 直接调用登录方法
//            self.singularity!.externalLogin(self.token!)
//        }
    }
    
    /** 断开连接 */
    func disConnect() {
        self.singularity!.disconnect()
    }
    
    /** 获取会话列表 */
    func getChatSessionList() {
        self.singularity?.getChatSessionList()
    }
    
    /** 获取未读消息 */
    func getUnreadMessages(chatSessionID: String) {
        self.singularity?.getUnreadMessages(chatSessionID)
    }
    
    /** 获取历史消息 */
    // 带id参数
    func getHistoryMessagesBeforeMessageID(chatSessionID: String, size: String, beforeMessageID: String) {
        self.singularity?.getHistoryMessagesBeforeMessageID(chatSessionID, size: size, beforeMessageID: beforeMessageID)
    }
    
    // 不带id参数
    func getHistoryMessages(chatSessionID: String, size: String) {
        self.singularity?.getHistoryMessages(chatSessionID, size: size)
    }
    
    /** 发送消息 */
    func sendMessage(targetID: String, content: String, messageToken: String, messageType: String) {
        self.singularity?.messageToUser(targetID, content: content, messageToken: messageToken, messageType: messageType)
    }
    
    /** 确认消息 */
    func confirmMessage(messageID: String, chatSessionID: String) {
        print("确认消息")
        self.singularity?.confirmMessage(messageID, chatSessionID: messageID)
    }
    
    /** 发送心跳 --- 保持在线状态 */
    func saveOnlineState() {
        // 调用心跳方法 -- 保持在线状态
        NSLog("心跳 ")
        self.singularity?.heart()
    }
}

// MARK：IMSingularityDelegate 代理方法的实现
extension DataUtil: IMSingularityDelegate {
    
    /** 用户在线状态改变回调方法 */
    func connectionState(state: Int) {
        switch(state) {
        case 0:
            NSLog("开始连接...")
        case 1:
            NSLog("连接成功...")
        case 2:
            NSLog("重新连接...")
        case 3:
            NSLog("断开连接...")
        default:
            break
        }
        self.state = state
        
        /** 发送会话状态改变的通知 */
        self.notification.postNotificationName("stateChangeNotification", object: nil, userInfo: ["state": self.state])
    }
    
    /** 登录的回调方法 */
    func loginCallback(request:UserInfo) {
        var loginResult: Bool = false
        // 判断是否登录成功
        if(request.login_result == "1") {    // 登录成功
            loginResult = true
            
            // 存储信息
            self.saveUserInfo(request)
            
        } else {    // 登录失败
            loginResult = false
        }
        
        /** 发送登录成功与否的通知 */
        self.notification.postNotificationName("loginResultNotification", object: nil, userInfo: ["result": loginResult])
    }
    
    /** 获取会话列表回调方法 */
    func receiveChatSessionList(request: IMSessionList) {
        
        // 判断是否有更新  有更新才发通知，若没有就不发通知更新UI

        // 检查是否有新的会话对象  -- 1. 有新的对象就发送更新会话列表的通知 2. 没有就不发送通知
        self.notification.postNotificationName("chatSessionListUpdateNotification", object: nil, userInfo: ["list": request.sessionList])
    }
    
    /** 获取未读消息回调方法 */
    func receiveUnreadMessages(request: UnreadMessages) {
//        for message in request.unread_messages {
//            print("message: \(message.message)")
//            print("message time: \(message.message_time)")
//            print("message type: \(message.message_type)")
//        }
        
        // 判断是否有未读消息  - 1. 有就发通知刷新页面  2.没有就不发通知
        self.notification.postNotificationName("chatSessionListUpdateNotification", object: nil, userInfo: ["list": request])
    }
    
    /** 获取历史消息回调 */
    func receiveHistoryMessages(request: HistoryMessages) {
        print("chat_session_id: \(request.chat_session_id)")
        print("historyMessagesCount: \(request.history_messages.count)")
        print("unreadMessagesCount: \(request.unread_messages.count)")
        
        // 判断是否有未读消息  - 1. 有就发通知刷新页面  2.没有就不发通知
        self.notification.postNotificationName("historyMessageListUpdateNotification", object:  nil, userInfo: ["list": request])
    }
    
    /** 发送消息的回调方法 */
    func messageCallback(request: Message) {
        print("send message: \(request.message)")
        
        // 信息发送成功发送通知
        self.notification.postNotificationName("messageSendSuccessNotification", object: nil, userInfo: ["message": request])
    }
    
    /** 收到新消息回调 */
    func receiveMessage(request: Message) {
        print("receive message: \(request.message)")
        self.notification.postNotificationName("receiveMessageNotification", object:  nil, userInfo: ["message": request])
    }
    
    /** 聊天对象状态改变回调方法 */
    func chatUserStatusChanged(request: UserState) {
        NSLog("状态改变user_name:\(request.user_name)")
        NSLog("状态改变状态:\(request.user_online_status)")
    }
    
}
