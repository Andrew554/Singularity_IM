//
//  SMChatTextTableViewCell.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/17.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

import IMSingularity_Swift

class SMChatTextTableViewCell: SMChatBaseTableViewCell {

    /**
     *  @brief  文本Lable
     */
    var mTextLable: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化控件
        let label = UILabel()
        
        label.numberOfLines = 0
        
        label.backgroundColor = UIColor.clearColor()
        
        label.font = UIFont.systemFontOfSize(14)
        
        self.mTextLable = label
        
        self.contentView.addSubview(self.mTextLable)
        
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
        
        self.mTextLable.text = model.message.message
        
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
        
        self.mTextLable.frame = self.model.textFrame
        
    }
    
    
    override func longPress(longPress: UILongPressGestureRecognizer) {
        
        if(longPress.state == UIGestureRecognizerState.Began) {
            
            self.becomeFirstResponder()
            
            self.mBubbleImageView.highlighted = true
            
            let copy = UIMenuItem(title: "复制", action: #selector(self.menuCopy(_:)))
            
            let retweet = UIMenuItem(title: "转发", action: #selector(self.menuRetweet(_:)))
            
            let retweetMultiple = UIMenuItem(title: "转发多条", action: #selector(self.menuRetweetMultiple(_:)))
            
            let remove = UIMenuItem(title: "删除", action: #selector(self.menuRemove(_:)))
            
            let menu = UIMenuController.sharedMenuController()
            
            menu.menuItems = [copy, retweet, retweetMultiple, remove]
            
            menu.setTargetRect(self.mBubbleImageView.frame, inView: self)
            
            menu.setMenuVisible(true, animated: true)
            
            // 注册菜单消失的通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.uiMenuControllerWillHideMenu), name: UIMenuControllerWillHideMenuNotification, object: nil)
        }
        
    }
    
    
    /**
     *	@brief	菜单隐藏时调用此方法
     *
     *	@return
     */
    @objc private func uiMenuControllerWillHideMenu() {

        self.mBubbleImageView.highlighted = false
        
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        return ((action == #selector(self.menuCopy(_:)))
             || (action == #selector(self.menuRetweet(_:)))
             || (action == #selector(self.menuRetweetMultiple(_:)))
             || (action == #selector(self.menuRemove(_:))))
        
    }
    
    
    //  MARK: --复制、删除、转发、转发多条
    @objc private func menuCopy(sender: AnyObject) {
        
        UIPasteboard.generalPasteboard().string = self.mTextLable.text
        
    }
    
    
    @objc private func menuRetweet(sender: AnyObject) {
        
    }
    
    
    @objc private func menuRetweetMultiple(sender: AnyObject) {
        
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
