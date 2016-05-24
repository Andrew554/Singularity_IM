//
//  DBUtil.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/9.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit
import FMDB
import IMSingularity_Swift

/** 数据库实例 */
class DBUtil: NSObject {
    
    var path: String!
    
    var db: FMDatabase!
    
    
    /** 单例 */
    class var sharedInstance: DBUtil {
        
        struct Static {
            
            static let instance: DBUtil = DBUtil()
            
        }
        
        return Static.instance
    }

    
    // MARK: 遍历构造器
    override init() {
        
        super.init()
        
        self.createDatabase()
        
    }
    
    
    /** 创建数据库 */
    func createDatabase() {
        
        let doc = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        
        NSLog("创建数据库: \(doc)")
        
        self.path = doc!.stringByAppendingString("/SingularityIM.sqlite")
        
        let db = FMDatabase(path: self.path)
        
        self.db = db
        
        // 创建表
        self.createSessionTable()
        
        self.createMessageTable()
    }
    
    
    /** 创建会话列表 t_sessionList */
    func createSessionTable() {
        
        // 打开数据库
        if(self.db.open()) {
            
            //  创表
            let result = db.executeUpdate("CREATE TABLE IF NOT EXISTS t_sessionList (id integer PRIMARY KEY AUTOINCREMENT, chat_session_id text NOT NULL, chat_session_type text, last_message text, last_message_id text, last_message_time text, last_message_type text, last_sender_id text, message_count text , target_id text, target_name text, target_online_status text, target_picture text);", withArgumentsInArray: nil)
            
            if(result) {
                
                NSLog("t_sessionList表成功")
                
            } else {
                
                NSLog("t_sessionList表失败")
                
            }
        }
    }
    
    
    /** 创建消息表 t_message */
    func createMessageTable() {
        
        // 打开数据库
        if(self.db.open()) {
            
            //  创表
            let result = db.executeUpdate("CREATE TABLE IF NOT EXISTS t_messageList (id integer PRIMARY KEY AUTOINCREMENT, chat_session_id text NOT NULL, chat_session_type text, sender_id text, message_id text, message text, message_time text, message_type text, message_token text);", withArgumentsInArray: nil)
            
            if(result) {
                
                NSLog("t_messageList表创建成功")
                
            } else {
                
                NSLog("t_messageList表创建失败")
                
            }
        }
    }

    
    /** 新增会话列表数据 */
    func insertToSessionTable(sessionList: Array<IMSession>) {
        
        // 删除表
        self.deleteTable("t_sessionList")
        
        // 创建表
        self.createSessionTable()
        
        for ses in sessionList {
            
            let chat_session_id = dealDataNull(ses.chat_session_id)
            
            let chat_session_type = dealDataNull(ses.chat_session_type)
            
            let last_message = dealDataNull(ses.last_message)
            
            let last_message_id = dealDataNull(ses.last_message_id)
            
            let last_message_time = dealDataNull(ses.last_message_time)
            
            let last_message_type = dealDataNull(ses.last_message_type)
            
            let last_sender_id = dealDataNull(ses.last_sender_id)
            
            let message_count = dealDataNull(ses.message_count)
            
            let target_id = dealDataNull(ses.target_id)
            
            let target_name = dealDataNull(ses.target_name)
            
            let target_online_status = dealDataNull(ses.target_online_status)
            
            let target_picture = dealDataNull(ses.target_picture)
            
            self.db.executeUpdate("INSERT INTO t_sessionList (chat_session_id, chat_session_type, last_message, last_message_id, last_message_time, last_message_type, last_sender_id, message_count, target_id, target_name, target_online_status, target_picture) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [chat_session_id, chat_session_type, last_message, last_message_id, last_message_time, last_message_type, last_sender_id, message_count, target_id, target_name, target_online_status, target_picture])
            
        }
        
        NSLog("插入 %d 条数据到 t_sessionList", sessionList.count)
    }
    
    
    /**
     *	@brief	空值处理
     *
     *	@param 	String?
     *
     *	@return
     */
    private func dealDataNull(data: String?) -> String {

        if(data == nil) {
            
            return ""
            
        }else {
            
            return data!
            
        }
    }

    
    /** 新增消息数据 */
    func insertTomessageTable(messageList: Array<Message>) {
        
        for msg in messageList {

            let chat_session_id = dealDataNull(msg.chat_session_id)
            
            let chat_session_type = dealDataNull(msg.chat_session_type)
            
            let sender_id = dealDataNull(msg.sender_id)
            
            let message_id = dealDataNull(msg.message_id)
            
            let message = dealDataNull(msg.message)
            
            let message_time = dealDataNull(msg.message_time)
            
            let message_type = dealDataNull(msg.message_type)
            
            let message_token = dealDataNull(msg.message_token)
            
            
            self.db.executeUpdate("INSERT INTO t_messageList (chat_session_id, chat_session_type, sender_id, message_id, message, message_time, message_type, message_token) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [chat_session_id, chat_session_type, sender_id, message_id, message, message_time, message_type, message_token])
        }
        
        NSLog("插入%d条数据到 t_messageList", messageList.count)
    }
    
        /**
          *	@brief	设置语音文件路径为消息
          *
          *	@param 	String 	消息id
          *	@param 	String 	文件路径
          *
          *	@return
          */
        func updatemessageTable(msgID: String, voiceFilePath: String) {
    
            let sql = "UPDATE t_messageList SET message = ? WHERE message_id = ?"
    
            self.db.executeUpdate(sql, withArgumentsInArray: [voiceFilePath, msgID])
        }

    
    
    /** 删除数据库表 */
    func deleteTable(tableName: String) {
        
        // 删除表
        self.db.executeUpdate("DROP TABLE IF EXISTS \(tableName);", withArgumentsInArray: nil)
        
        NSLog("删除\(tableName)表")
    }
    
    
    /** 遍历会话列表数据 */
    func querySessions(sql: String) -> Array<IMSession>{
        
        var arr:Array<IMSession> = Array()
        
        // 打开数据库
        self.db.open()
        
        // 1. 执行查询语句
        do {
            let resultSet = try self.db.executeQuery(sql, values: nil)
            
            // 2. 遍历结果
            while resultSet.next() {
                
                let session = IMSession()
                
                let chat_session_id = resultSet.stringForColumn("chat_session_id")
                session.chat_session_id = chat_session_id
                
                let chat_session_type = resultSet.stringForColumn("chat_session_type")
                session.chat_session_type = chat_session_type
                
                let last_message = resultSet.stringForColumn("last_message")
                session.last_message = last_message
                
                let last_message_id = resultSet.stringForColumn("last_message_id")
                session.last_message_id = last_message_id
                
                let last_message_time = resultSet.stringForColumn("last_message_time")
                session.last_message_time = last_message_time
                
                let last_message_type = resultSet.stringForColumn("last_message_type")
                session.last_message_type = last_message_type
                
                let last_sender_id = resultSet.stringForColumn("last_sender_id")
                session.last_sender_id = last_sender_id
                
                let message_count = resultSet.stringForColumn("message_count")
                session.message_count = message_count
                
                let target_id = resultSet.stringForColumn("target_id")
                session.target_id = target_id
                
                let target_name = resultSet.stringForColumn("target_name")
                session.target_name = target_name
                
                let target_online_status = resultSet.stringForColumn("target_online_status")
                session.target_online_status = target_online_status
                
                let target_picture = resultSet.stringForColumn("target_picture")
                session.target_picture = target_picture
                
                arr.append(session)
            }
        }catch {
            print("查询出错")
        }
        NSLog("从数据库查询 %d 条数据", arr.count)
        // 返回查询结果
        return arr
    }
    
    
    /** 遍历消息数据 */
    func queryMessages(sql: String) -> Array<Message>{
    
        var arr:Array<Message> = Array()
        
        // 打开数据库
        self.db.open()
        
        // 1. 执行查询语句
        do {
            let resultSet = try self.db.executeQuery(sql, values: nil)
            
            // 2. 遍历结果
            while resultSet.next() {
                let msg = Message()
                
                let chat_session_id = resultSet.stringForColumn("chat_session_id")
                msg.chat_session_id = chat_session_id
                
                let chat_session_type = resultSet.stringForColumn("chat_session_type")
                msg.chat_session_type = chat_session_type
                
                let sender_id = resultSet.stringForColumn("sender_id")
                msg.sender_id = sender_id
                
                let message_id = resultSet.stringForColumn("message_id")
                msg.message_id = message_id
                
                let message = resultSet.stringForColumn("message")
                msg.message = message
                
                let message_time = resultSet.stringForColumn("message_time")
                msg.message_time = message_time
                
                let message_type = resultSet.stringForColumn("message_type")
                msg.message_type = message_type
                
                let message_token = resultSet.stringForColumn("message_token")
                msg.message_token = message_token
                
                arr.insert(msg, atIndex: 0)
            }
        }catch {
            print("查询出错")
        }
        NSLog("从数据库查询 %d 条数据", arr.count)
        // 返回查询结果
        return arr
    }

}
