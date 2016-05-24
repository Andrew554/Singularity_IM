//
//  SMMessageFrame.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/31.
//  Copyright © 2016年 SinObjectC. All rights reserved.


import UIKit

import IMSingularity_Swift


// 消息类型枚举
public enum MessageType {
    case Text
    case Image
    case Voice
}

// 是否显示时间Label枚举
public enum ShowTimeLabel {
    case YES
    case NO
}

// 位置枚举
public enum AlignOrientation {
    case Left
    case Right
}

class SMMessageFrame: NSObject {
    
    /** 消息数据 */
    var message: Message! {
        
        didSet {
            
            self.setMessageType()
            
            self.setAlign()
            
            self.setMessageFrame()
            
        }
        
    }
    
    /** 自己的frame */
    var frame: CGRect!
    
    /** 头像 */
    var headFrame: CGRect!
    
    /** 气泡 */
    var mBubbleImageViewFrame: CGRect!
    
    /** 消息 */
    var textFrame: CGRect!
    
    /** 方向 */
    var alignOrientation: AlignOrientation = .Left
    
    /** 消息类型 */
    var messageType: MessageType = .Text
    
    /** 时间标签 */
    var showTimeLable: ShowTimeLabel = .YES
    
    /** 语音文件句柄 */
    var writeHandle: NSFileHandle?
    
    /** 用来获取下载的文件的文件名 */
    var response: NSURLResponse!
    
    /** 语音长度 */
    var voiceLength: Int64 = 0
    
    // 数据库操作实体
    var dbUtil: DBUtil = DBUtil.sharedInstance

    var receiveData: NSMutableData!
    
    /** 设置消息类型 */
    private func setMessageType() {
        
        switch message.message_type! {
            
            case "0":
                
                self.messageType = .Text
            
            case "1":

                self.messageType = .Image

            case "2":

                self.messageType = .Voice
            
            default:
                
                self.messageType = .Text
        }
    }
    
    
    /** 设置消息对象 */
    private func setAlign() {
        
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        
        if(userId == message.sender_id) {
            
            self.alignOrientation = .Right
            
        }else {
            
            self.alignOrientation = .Left
            
        }
    }
    
    
    /**
     *	@brief	设置是否显示时间标签
     *
     *	@return
     */
    private func setShowTime() {
        
    }
    

    /**
     *	@brief	根据数据源设置frame
     *
     */
    private func setMessageFrame() {

        let mHeadSize = CGSizeMake(kWidthHead, kHeightHead)
        
        let mHeadY = kTopHead
        
        var mHeadX: CGFloat = 0
        
        let top    = kTop_OffsetTextWithHead + kTopHead
        
        let traing = kH_OffsetTextWithHead + kWidthHead + kLeadingHead
        
        let size = self.message.message!.stringSizeWith(14, width: SMScreenW - kMaxOffsetText - traing)
        
        var mBubbleX: CGFloat = 0
        
        let mBubbleY = mHeadY - kOffsetTopHeadToBubble
        
        
        switch self.alignOrientation {
            
            case .Right:
            
                mHeadX = SMScreenW - kTraingHead - kWidthHead
            
            case .Left:
        
                mHeadX = kTraingHead
        }
        
        self.headFrame = CGRectMake(mHeadX, mHeadY, mHeadSize.width, mHeadSize.height)
        
        
        switch self.messageType {
            
            case .Text:
            
                switch self.alignOrientation {
            
                    case .Right:
            
                        self.textFrame = CGRectMake(SMScreenW - traing - size.width, top, size.width, size.height)
                
                        mBubbleX = self.textFrame.minX - 20
            
                    case .Left:
            
                        self.textFrame = CGRectMake(traing, top, size.width, size.height)
                
                        mBubbleX = self.headFrame.maxX
            
                }
            
                let mBubbleSize = CGSizeMake(self.textFrame.width + 20 + kH_OffsetTextWithHead, 2*(kTop_OffsetTextWithHead) + kTopHead + self.textFrame.height)
     
                self.mBubbleImageViewFrame = CGRectMake(mBubbleX, mBubbleY, mBubbleSize.width, mBubbleSize.height)
            
         
        case .Image:
            
            let top     = kTopHead - kOffsetTopHeadToBubble
            
            let leading = kOffsetHHeadToBubble + kWidthHead + kLeadingHead
            
            let traing  = kMaxOffsetText
            
            var imageW: CGFloat = 0
            
            var imageH: CGFloat = 0
            
            let image = UIImageView(image: UIImage(data: NSData(contentsOfURL: NSURL(string: self.message.message!)!)!))
            
            // 图片的长宽比例
            let scale: CGFloat = image.width / image.height
            
            if(image.width > image.height) {    // 如果比较宽
                
                imageW = 120
                
                imageH = imageW/scale
                
            }else { // 比较长
                
                imageH = 120
                
                imageW = imageH * scale
            }
            
//            let imageMaxW = (SMScreenW - leading - traing)
//            let imageMaxW: CGFloat = 100
//            
//            imageW = (image.width > imageMaxW) ? imageMaxW : image.width
//            
//            imageH = (image.height > kMaxHeightImageView) ? kMaxHeightImageView : image.height
            
            switch self.alignOrientation {
                
                case .Right:
                    
                    self.textFrame = CGRectMake(SMScreenW - leading - imageW, top, imageW, imageH)
                
                case.Left:
                    
                    self.textFrame = CGRectMake(leading, top, imageW, imageH)

            }
            
            self.mBubbleImageViewFrame = self.textFrame
        
            
        case .Voice:
            
            let scale: CGFloat = 0.6
            
            let voiceSize = CGSizeMake(120 * scale, 33 * scale)
            
            // 根据语音时间长度计算出显示长度
            
            switch self.alignOrientation {
                
                case .Right:
                     
                    self.textFrame = CGRectMake(SMScreenW - traing - voiceSize.width, top, voiceSize.width, voiceSize.height)
                    
                    mBubbleX = self.textFrame.minX - 20
                
                case .Left:
                
                    self.textFrame = CGRectMake(traing, top, voiceSize.width, voiceSize.height)
                    
                    mBubbleX = self.headFrame.maxX
            
            }
            
            let mBubbleSize = CGSizeMake(self.textFrame.width + 20 + kH_OffsetTextWithHead, 2*(kTop_OffsetTextWithHead) + kTopHead + self.textFrame.height)
            
            self.mBubbleImageViewFrame = CGRectMake(mBubbleX, mBubbleY, mBubbleSize.width, mBubbleSize.height)
            
            // 下载语音文件
            self.initData()
        }
        
        self.frame = CGRectMake(0, 0, SMScreenW, self.mBubbleImageViewFrame.maxY + kCellBottomMargin)
    }
    
    
    /**
     *	@brief	判断音频文件是否存在，不存在则下载
     *
     *	@return
     */
    private func initData() {
        
        let fileManager = NSFileManager.defaultManager()
        
        let filePath = self.message.message_id!
        
        let isExist = fileManager.fileExistsAtPath(getFilePathByName("\(filePath).amr"))
        
        if(isExist == true) {   // 文件存在
            
            NSLog("文件存在")
            
        }else { // 文件不存在
            
            NSLog("文件不存在")
            
//            self.downloadFile(self.message.message!)
            
        }
        
    }
    
    
    /**
     *	@brief	下载文件
     *
     *	@return
     */
    private func downloadFile(url: String) {
        
        NSLog("下载路径: \(url)")
        
        // 创建下载路径
        let url = NSURL(string: url)
        
        // 创建一个请求
        let request = NSURLRequest(URL: url!)
        
        // 发送请求(使用代理的方式)
        NSURLConnection(request: request, delegate: self)
        NSLog("0")
    }


}

// MARK: NSURLConnectionDataDelegate 代理方法

extension SMMessageFrame: NSURLConnectionDataDelegate {
    
    /**
     *	@brief	当接收到服务器的响应 (连通了服务器) 时会调用
     *
     */
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        self.response = response
        
        self.receiveData = NSMutableData()
        NSLog("1")
//        //  1. 创建文件存储路径
//        let filePath = getFilePathByName("\(self.message.message_id).amr")
//        
//        //  2. 创建一个空的文件到沙盒中
//        let mgr = NSFileManager.defaultManager()
//        
//        //  3. 刚创建完毕的大小是0字节
//        mgr.createFileAtPath(filePath, contents: nil, attributes: nil)
        
        //  4. 获取完整的文件的长度
        self.voiceLength = response.expectedContentLength
        
        //  5. 创建写数据的文件句柄
//        self.writeHandle = NSFileHandle(forWritingAtPath: filePath)
        
    }
    
    
    
    /**
     *	@brief	当接收到服务器的数据时会调用（可能会被调用多次，每次只传递部分数据）
     *
     */
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        //  一点一点的接收数据(拿到一点数据就直接写入文件，避免文件存在于内存中)
        NSLog("接收到服务器的数据 --- %d", data.length)
        
        self.receiveData.appendData(data)
        
        // 把data写入到创建的空文件中，但是不能使用wirteToFile(会覆盖)
        
        // 指针移动到文件的尾部
//        self.writeHandle!.seekToEndOfFile()
        
        // 从当前移动的位置写入数据
//        self.writeHandle!.writeData(data)
        NSLog("2")
    }
    
    
    /**
     *	@brief	当服务器的数据加载完毕时就会调用
     *
     */
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        NSLog("语音下载完毕!")
        
        // 关闭连接, 不再输入数据在文件中
//        self.writeHandle!.closeFile()
        
        // 销毁
//        self.writeHandle = nil
        
        // 对进度进行清空
        self.voiceLength = 0
        NSLog("3")
        
        let filePath = getFilePathByName(self.response!.suggestedFilename!)
    
        self.receiveData.writeToFile(filePath, atomically: true)
        
    }
    
    
    /**
     *	@brief	请求错误（失败）的时候调用（请求超时\断网\没有网\，一般指客户端错误）
     *
     */
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        NSLog("下载失败: %@", error)
        
    }
    
    
    //转换amr到wav
//   VoiceConverter.arm
    
   }

