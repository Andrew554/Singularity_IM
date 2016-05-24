//
//  SMEmojiToolbar.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/5/5.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

public enum SMEmtionType: Int {
    
    case Default = 1001
    
}

let SMEmotionToolbarButtonMaxCount: Int = 5


protocol SMEmojiToolbarDelegate {
    
    func emojiToolbarDidSelectedButton(toolbar: SMEmojiToolbar, emojiType: SMEmtionType)
    
}

class SMEmojiToolbar: UIView {

    var delegate: SMEmojiToolbarDelegate!
    
    var selectedButton: UIButton!
    
    var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.添加按钮
        self.selectedButton = self.setupButtonWithTag("默认", tag: .Default)
        
        self.setupButtonWithTag("Emoji", tag: .Default)
        
        self.setupButtonWithTag("浪小花", tag: .Default)
        
        self.selectedButton.selected = true
        
        // 发送按钮
        let btn = UIButton()
        
        btn.backgroundColor = navigationBarTintColor
        
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Selected)
        
        btn.setTitle("发送", forState: .Normal)
        
        self.addSubview(btn)
        
        self.sendButton = btn
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    /**
     *	@brief	添加按钮
     *
     *	@param 	String 	按钮文字
     *	@param 	SMEmtionType 按钮枚举
     */
    private func setupButtonWithTag(title: String, tag: SMEmtionType) -> UIButton {

        let button = UIButton()
        
        button.tag = tag.rawValue
        
        // 文字
        button.setTitle(title, forState: .Normal)
        
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Selected)
        
        button.addTarget(self, action: #selector(self.buttonClick(_:)), forControlEvents: .TouchUpInside)
        
        button.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        
        // 添加按钮
        self.addSubview(button)
        
        // 设置背景图片
//        let count = self.subviews.count
        
//        if(count == 1) {    // 第一个按钮
//            
//            button.setBackgroundImage(UIImage(named: "compose_emotion_table_left_normal"), forState: .Normal)
//            
//            button.setBackgroundImage(UIImage(named: "compose_emotion_table_left_selected"), forState: .Selected)
//            
//        }else if(count == SMEmotionToolbarButtonMaxCount) { // 最后一个按钮
//            
            button.setBackgroundImage(UIImage(named: "compose_emotion_table_right_normal"), forState: .Normal)

            button.setBackgroundImage(UIImage(named: "compose_emotion_table_right_selected"), forState: .Selected)
//
//        }else {    // 中间按钮
        
//            button.setBackgroundImage(UIImage(named: "compose_emotion_table_mid_normal"), forState: .Normal)
        
//            button.setBackgroundImage(UIImage(named: "compose_emotion_table_mid_selected"), forState: .Selected)
//        }
        
        return button
    }
    
    
    /**
     *	@brief	监听按钮点击事件
     *
     *	@param 	UIButton 	按钮类型
     *
     */
    @objc private func buttonClick(btn: UIButton) {

        // 1.控制按钮状态
        self.selectedButton.selected = false
        
        btn.selected = true
    
        self.selectedButton = btn
        
        // 2.通知代理
        self.delegate.emojiToolbarDidSelectedButton(self, emojiType: .Default)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置工具条按钮的frame
        let buttonW = self.width / (CGFloat)(SMEmotionToolbarButtonMaxCount)
        
        let buttonH = self.height
        
        for i in 0...self.subviews.count-2 {
         
            let button = self.subviews[i]
            
            button.width = buttonW
            
            button.height = buttonH
            
            button.x = (CGFloat)(i) * buttonW
        }
        
        // 2.发送按钮
        self.sendButton.width = buttonW
    
        self.sendButton.height = buttonH
        
        self.sendButton.x = self.width - self.sendButton.width

    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
