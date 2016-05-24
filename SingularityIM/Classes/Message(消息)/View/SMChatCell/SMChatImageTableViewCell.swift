//
//  SMChatImageTableViewCell.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/17.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

import SDWebImage

import MJPhotoBrowser
import IMSingularity_Swift


class SMChatImageTableViewCell: SMChatBaseTableViewCell {

    /**
     *  @brief  图片所在ImageView
     */
    var mImageView: UIImageView!
    
    var mImage: UIImageView!
    
    var lastFrame: CGRect!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        
        let imageView = UIImageView()
        
        imageView.userInteractionEnabled = true
        
        self.mImageView = imageView
        
        self.mImageView.backgroundColor = UIColor.clearColor()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageBeenTaped(_:)))
        
        self.mBubbleImageView.addGestureRecognizer(tap)
        
        self.contentView.insertSubview(self.mImageView, atIndex: 0)
        
        // 注册菜单消失的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.UIMenuControllerWillHideMenu), name: UIMenuControllerWillHideMenuNotification, object: nil)
    }
    
    
    /**
     *	@brief	菜单隐藏时调用此方法
     *
     *	@return
     */
    @objc private func UIMenuControllerWillHideMenu() {
        
        self.mBubbleImageView.highlighted = false
        
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    /**
     *	@brief	设置数据模型
     *
     *	@param 	Message 	消息模型
     *
     *	@return
     */
    override func set_Model(model: SMMessageFrame) {

        super.set_Model(model)
    
        self.mImageView.sd_setImageWithURL(NSURL(string: self.model.message.message!), placeholderImage: UIImage(named: "new_feature_2"))
        
        self.layoutUI()
        
    }
    
    
    /**
     *	@brief	设置ui布局
     *
     *	@return
     */
    override func layoutUI() {
        
        super.layoutUI()
        
        self.mBubbleImageView.frame = self.model.mBubbleImageViewFrame
        
        self.mImageView.frame = self.model.textFrame
        
        switch self.model.alignOrientation {
            
            case .Right:
            
                self.mBubbleImageView.image = UIImage(named: "chat_send_imagemask")?.stretchableImageWithLeftCapWidth(30, topCapHeight: 30)
            
            case .Left:
            
                self.mBubbleImageView.image = UIImage(named: "chat_recive_imagemask")?.stretchableImageWithLeftCapWidth(30, topCapHeight: 30)

        }
        
        self.mBubbleImageView.highlightedImage = nil
        
        self.mBubbleImageView.backgroundColor = UIColor.clearColor()
        
        NSLog("图片:\(self.mImageView.frame)")
        
        NSLog("气泡: \(self.mBubbleImageView.frame)")

    }
    
    
    /**
     *	@brief	图片点击
     *
     *	@param 	UITapGestureRecognizer 	点击手势
     *
     *	@return
     */
    @objc func imageBeenTaped(tap: UITapGestureRecognizer) {
        
        // 创建图片浏览器
//        let browser = MJPhotoBrowser()
//
//        // 设置图片浏览器显示的所有图片
//
//        let photos = NSMutableArray()
//
//        let photo = MJPhoto()
//
//        // 设置图片的路径
//        photo.url = NSURL(string: self.model.message.message!)
//
//        // 设置来源于哪一个UIImageView
//        photo.srcImageView = self.mImageView
//
//        photos.addObject(photo)
//
//        browser.photos = photos as [AnyObject]
//
//        // 显示浏览器
//        browser.show()
        
        
        // 1. 创建遮罩
        let mask = UIView()

        mask.frame = UIScreen.mainScreen().bounds

        mask.backgroundColor = UIColor.blackColor()

        let tapMask = UITapGestureRecognizer(target: self, action: #selector(self.maskTap(_:)))

        mask.addGestureRecognizer(tapMask)
        
        UIApplication.sharedApplication().keyWindow?.addSubview(mask)
        
        
        // 2. 添加图片到遮盖上
        let photoImage = self.mImageView.image!
        
        // copy一张和原始图片一样的图片
        mImage = UIImageView()
        
        mImage?.sd_setImageWithURL(NSURL(string: self.model.message.message!), placeholderImage: photoImage)

        mImage.userInteractionEnabled = true

        // 将mImageView.frame从self坐标系转换 为cover坐标系
        mImage.frame = mask.convertRect(self.mImageView.frame, fromView: self)

        // 记录原始图片坐标便于点击缩小为原来位置
        self.lastFrame = mImage.frame
        
        mask.addSubview(mImage)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTap(_:)))

        mImage.addGestureRecognizer(tap)

        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.imageLongTap(_:)))

        mImage.addGestureRecognizer(longTap)

        //  3. 放大
        UIView.animateWithDuration(0.25) { 
            
            var frame = self.mImage.frame
            
            frame.size.width = mask.width
            
            frame.size.height = frame.size.width * (self.mImage.height / self.mImage.width)
            
            frame.origin.x = 0
            
            frame.origin.y = (mask.height - frame.size.height) * 0.5
            
            self.mImage.frame = frame
        }
    }
    
    
    /**
     *	@brief	气泡长按时间
     *
     *	@param 	UILongPressGestureRecognizer 	手势
     *
     *	@return
     */
    override func longPress(longPress: UILongPressGestureRecognizer) {

        if(longPress.state == UIGestureRecognizerState.Began) {
            
            self.becomeFirstResponder()
            
            self.mBubbleImageView.highlighted = true
            
            let copy = UIMenuItem(title: "复制", action: #selector(self.menuCopy(_:)))
            
            let remove = UIMenuItem(title: "删除", action: #selector(self.menuRemove(_:)))
            
            let menu = UIMenuController.sharedMenuController()
            
            menu.menuItems = [copy, remove]
            
            menu.setTargetRect(self.mBubbleImageView.frame, inView: self)
            
            menu.setMenuVisible(true, animated: true)
            
        }
    }
    
    
    /**
     *	@brief	点击放大的图片
     *
     *	@param 	UITapGestureRecognizer 	点击手势
     *
     *	@return
     */
    @objc func imageTap(tap: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.25, animations: { 
            
            tap.view?.backgroundColor = UIColor.clearColor()
            
            self.mImage.frame = self.lastFrame
            
            }) { (finished) in
                
                tap.view?.superview?.removeFromSuperview()
                
                self.mImage = nil
                
        }
        
    }
    
    
    /**
     *	@brief	长按放图片事件
     *
     *	@param 	UITapGestureRecognizer 	长按手势
     *
     *	@return
     */
    @objc func imageLongTap(longTap: UILongPressGestureRecognizer) {
        
        NSLog("长按")
        if(longTap.state == .Began) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        
        let sendToFriendAction = UIAlertAction(title: "发送给好友", style: .Default) { (finished) in
            
            NSLog("发送给好友")
            
        }
        
        let saveImageAction = UIAlertAction(title: "保存图片", style: .Default) { (finished) in
            
            NSLog("保存图片")
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(sendToFriendAction)
        alert.addAction(saveImageAction)
        alert.addAction(cancelAction)
        

//            UIApplication.sharedApplication().keyWindow?.addSubview(alert.view)
//        self.controller.navigationController?.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    /**
     *	@brief	点击放大的图片
     *
     *	@param 	UITapGestureRecognizer 	点击手势
     *
     *	@return
     */
    @objc func maskTap(tap: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.25, animations: {
            
            tap.view?.backgroundColor = UIColor.clearColor()
            
            self.mImage.frame = self.lastFrame
            
        }) { (finished) in
            
            tap.view?.removeFromSuperview()
            
            self.mImage = nil
            
        }

    }

    
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        return ((action == #selector(self.menuCopy(_:)))
            || (action == #selector(self.menuRemove(_:))))
        
    }
    
    
    //  MARK: --复制、删除
    @objc private func menuCopy(sender: AnyObject) {
        
        UIPasteboard.generalPasteboard().image = self.mImageView.image
        
    }
    
    
    @objc private func menuRemove(sender: AnyObject) {
        
        (self.nextResponder() as! UIResponder_Router).routerEventWithType(.RemoveEvent, userInfo: [kModelKey: self.model])
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
