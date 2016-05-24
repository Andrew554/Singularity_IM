//
//  SMComposeToolbar.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/12.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

/** 枚举类型 */
public enum SMComposeToolBarButtonType: Int {
    
    case Voice = 101
    
    case Emotion
    
    case Add
}


/** 代理协议 */
protocol SMComposeToolbarDelegate {
    
    func sendMessage(text: String)
    
    func composeToolDidClickedButton(toolbar: SMComposeToolbar, buttonType: Int)
    
}


/** 发消息工具栏 */
class SMComposeToolbar: UIView {
    
    // 自定义Emoji键盘
    var emojiKeyboard: UIView = {
        
        let keyView = SMEmojiKeyboard()
        
        keyView.width = SMScreenW
        
        keyView.height = 216
        
        return keyView
        
    }()
    
    
    // 自定义更多键盘
    var moreKeyboard: UIView = {
        
        let moreView = SMMoreKeyboard()
        
        moreView.backgroundColor = UIColor.magentaColor()
        
        moreView.width = SMScreenW
        
        moreView.height = 216
        
        return moreView
        
    }()
    
    var showVoiceButton: Bool = true
    
    var showInputTextViewButton: Bool = false
    
    var showEmojiButton: Bool = false
    
    var showAddButton: Bool = false
    
    var voiceButton: UIButton!
    
    var inputTextView: UITextView!
    
    var inputPressButton: UIButton!
    
    var emojiButton: UIButton!
    
    var addButton: UIButton!

    var delegate: SMComposeToolbarDelegate!
    
    // 是否正在切换键盘
    var changingKeyboard: Bool = false
    
    convenience init() {
        
        self.init(frame: CGRectZero)
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = InputViewBgColor
        
        self.voiceButton = self.addButtonWithIcon("voice_input", highIcon: "voice_input", tag: .Voice)
        
        self.emojiButton = self.addButtonWithIcon("emoji_input", highIcon: "emoji_input_select", tag: .Emotion)
        
        self.addButton = self.addButtonWithIcon("add_input", highIcon: "add_input_select", tag: .Add)
        
        self.addTextView()
        
        self.addPressButton()
        
        // 默认显示键盘图标
        
        self.setShowInputTextViewButton(false)
        
        self.layoutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    /**
     *	@brief	添加一个按钮
     *
     *	@param 	String 	默认图标
     *	@param 	String 	高亮图标
     *	@param 	SMComposeToolBarButtonType 	按钮枚举类型
     *
     *	@return	按钮
     */
    private func addButtonWithIcon(icon: String, highIcon: String, tag: SMComposeToolBarButtonType) -> UIButton {

        let button = UIButton()
        
        button.tag = tag.rawValue
        
        // 添加事件监听
        button.addTarget(self, action: #selector(self.buttonClick(_:)), forControlEvents: .TouchUpInside)
        
        button.setImage(UIImage(named: icon), forState: .Normal)
        
        button.setImage(UIImage(named: highIcon), forState: .Highlighted)
        
        self.addSubview(button)
        
        return button
    }
    
    
    /**
     *	@brief	添加输入框
     *
     *	@return	nil
     */
    private func addTextView() {
        
        let textView = UITextView()
        
        textView.layer.cornerRadius = 5
        
        textView.layer.borderColor = InputTextViewBorderColor.CGColor
        
        textView.layer.borderWidth = 1.0
        
        textView.returnKeyType = .Send
        
        textView.font = UIFont.systemFontOfSize(17)
        
        textView.delegate = self
        
        self.inputTextView = textView
        
        self.addSubview(self.inputTextView)

    }
    
    
    /**
     *	@brief	添加按住说话按钮
     *
     *	@return
     */
    private func addPressButton() {
        
        let button = UIButton()
        
        button.setTitle("按 住 说 话", forState: .Normal)
        
        button.backgroundColor = InputViewBgColor
        
        button.setTitleColor(InputTextViewBorderColor, forState: .Normal)
        
        button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        
//        button.addTarget(self, action: "", forControlEvents: )
        
        button.layer.cornerRadius = 5
        
        button.layer.borderColor = InputTextViewBorderColor.CGColor
        
        button.layer.borderWidth = 1
        
        button.tag = 100
        
        self.inputPressButton = button
        
        self.addSubview(self.inputPressButton)
        
    }
    
    
    /**
     *	@brief	设置显示语音按钮
     *
     *	@return
     */
    private func setShowVoiceButton(show: Bool) {

        self.showVoiceButton = show
        
        if(show) {  // 显示语音按钮  现在为键盘
        
            self.voiceButton.setImage(UIImage(named: "voice_input"), forState: .Normal)
            
            self.voiceButton.setImage(UIImage(named: "voice_input"), forState: .Highlighted)
            
        } else {    // 切换为键盘按钮  现在为语音
            
            self.voiceButton.setImage(UIImage(named: "keyboard_input"), forState: .Normal)
            
            self.voiceButton.setImage(UIImage(named: "keyboard_input"), forState: .Highlighted)

        }
    }
    
    
    /**
     *	@brief	设置显示文本框还是按住说话按钮
     *
     *	@return
     */
    private func setShowInputTextViewButton(show: Bool) {
        
        self.showInputTextViewButton = show
        
        if(!show) {  // 显示文本框
            
            self.inputTextView.hidden = false
            
            self.inputPressButton.hidden = true
            
        } else {    // 切换为按住说话按钮
            
            self.inputPressButton.hidden = false
            
            self.inputTextView.hidden = true
            
        }
    }
    
    
    /**
     *	@brief	设置显示表情按钮
     *
     */
    private func setShowEmojiButton(show: Bool) {
        
        self.showEmojiButton = show
        
        if(show) {  // 显示表情按钮
            
            self.emojiButton.setImage(UIImage(named: "emoji_input"), forState: .Normal)
            
            self.emojiButton.setImage(UIImage(named: "emoji_input"), forState: .Highlighted)
            
        } else {   // 切换为键盘按钮
            
            self.emojiButton.setImage(UIImage(named: "keyboard_input"), forState: .Normal)
            
            self.emojiButton.setImage(UIImage(named: "keyboard_input"), forState: .Highlighted)
        }
    }
    
    /**
     *	@brief	设置显示表情按钮
     *
     */
    private func setShowAddButton(show: Bool) {
        
        self.showAddButton = show
        
    }

    
    
    /**
     *	@brief	监听按钮点击
     *
     *	@param 	UIButton 	触发源
     *
     */
    @objc private func buttonClick(button: UIButton) {
        
        self.setShowInputTextViewButton(false)
        
        switch(button.tag) {
           
            case SMComposeToolBarButtonType.Voice.rawValue:
                
                self.setShowEmojiButton(true)
            
                self.clickVoice()
            
            case SMComposeToolBarButtonType.Emotion.rawValue:
            
                self.setShowVoiceButton(true)
            
                self.clickEmoji()
            
            case SMComposeToolBarButtonType.Add.rawValue:

                 self.setShowVoiceButton(true)

                 self.setShowEmojiButton(true)
            
                 self.clickMore()
            
            default:
                
                break
        }
        
        self.delegate.composeToolDidClickedButton(self, buttonType: button.tag)
        
    }
    
    
    /**
     *	@brief  点击语音
     *
     */
    private func clickVoice() {
        
        // 正在切换键盘
        self.changingKeyboard = true
        
        if(self.showVoiceButton == true) {
        
            self.setShowVoiceButton(false)
            
            self.setShowInputTextViewButton(true)
            
            // 键盘切换完成
            self.changingKeyboard = false
            
            self.inputTextView.resignFirstResponder()
            
        }else {
            
            self.inputTextView.inputView = nil
            
            self.setShowVoiceButton(true)
            
            self.setShowInputTextViewButton(false)
            
            self.inputTextView.resignFirstResponder()
            
            // 记录是否正在更换键盘
            // 更换键盘完毕
            self.changingKeyboard = false
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.1)), dispatch_get_main_queue()) {
                
                // 打开键盘
                self.inputTextView.becomeFirstResponder()
                
            }
        }
    }

    
    /**
     *	@brief	点击表情
     *
     */
    private func clickEmoji() {

        // 正在切换键盘
        self.changingKeyboard = true
        
        if(self.inputTextView.inputView != nil) {   // 当前显示的是自定义键盘，切换为系统键盘
            
            if(self.showAddButton == true) {  // 如果正在显示的是自定义更多键盘
                
                self.inputTextView.inputView = self.emojiKeyboard
                
                // 显示键盘图片
                self.setShowEmojiButton(false)
                
            }else { // 显示的是自定义表情键盘
                
                self.inputTextView.inputView = nil
                
                // 显示表情图片
                self.setShowEmojiButton(true)
                
            }
            
            self.setShowAddButton(false)
            
        }else {   // 当前显示的系统自带的键盘，切换为自定义键盘
            
            // 如果临时更换了文本框的键盘，一定要重新打开键盘
            self.inputTextView.inputView = self.emojiKeyboard
            
            // 不显示表情图片，显示键盘图片
            self.setShowEmojiButton(false)
        }
        
        // 关闭键盘
        self.inputTextView.resignFirstResponder()
        
        // 记录是否正在更换键盘
        // 更换键盘完毕
        self.changingKeyboard = false
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.1)), dispatch_get_main_queue()) {
            
            // 打开键盘
            self.inputTextView.becomeFirstResponder()
            
        }
        
    }
    
    
    /**
     *	@brief	点击更多
     *
     */
    private func clickMore() {
        
        // 正在切换键盘
        self.changingKeyboard = true
        
        if(self.inputTextView.inputView != nil) {   // 当前显示的是自定义键盘，切换为系统键盘
            
            if(self.showAddButton == false) {  // 如果正在显示的是自定义表情键盘
                
                self.inputTextView.inputView = self.moreKeyboard
                
                self.showAddButton = true
                
            }else {   // 显示的是自定义更多键盘
                
                self.inputTextView.inputView = nil
                
                 self.showAddButton = false

            }
            
            // 显示表情图片
            self.setShowAddButton(true)
            
        }else {   // 当前显示的系统自带的键盘，切换为自定义更多键盘
            
            // 如果临时更换了文本框的键盘，一定要重新打开键盘
            self.inputTextView.inputView = self.moreKeyboard
            
            self.setShowAddButton(true)
    
        }
        
        // 关闭键盘
        self.inputTextView.resignFirstResponder()
        
        
        // 记录是否正在更换键盘
        // 更换键盘完毕
        self.changingKeyboard = false
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.1)), dispatch_get_main_queue()) {
            
            // 打开键盘
            self.inputTextView.becomeFirstResponder()
            
        }
        
    }
    
    
    /**
     *	@brief	布局约束
     *
     *	@return
     */
    private func layoutUI() {
        
        let margin: CGFloat = 6
        
        let count = self.subviews.count
        
        NSLog("self.width：\(self.width)")
        
        let buttonW = (self.width - 200 - (5 * margin))/(CGFloat)(count - 2)
    
        NSLog("buttonW数：\(buttonW)")
        
        let buttonH = buttonW
        
        self.voiceButton.snp_makeConstraints { (make) in
            
            make.width.equalTo(buttonW)
            
            make.height.equalTo(buttonH)
            
            make.left.equalTo(margin)
            
            make.bottom.equalTo(-10)
        }
        
        self.inputTextView.snp_makeConstraints { (make) in
            
            make.width.equalTo(200)
            
            make.top.equalTo(margin)
            
            make.bottom.equalTo(-margin)
            
            make.left.equalTo(self.voiceButton.snp_right).offset(margin)
        }
        
        self.inputPressButton.snp_makeConstraints { (make) in
            
            make.width.equalTo(200)
            
            make.height.equalTo(38)
            
            make.centerY.equalTo(0)
            
            make.left.equalTo(self.voiceButton.snp_right).offset(margin)
        }
        
        self.emojiButton.snp_makeConstraints { (make) in
            
            make.width.equalTo(buttonW)
            
            make.height.equalTo(buttonH)
            
            make.left.equalTo(self.inputTextView.snp_right).offset(margin)
            
            make.bottom.equalTo(-10)
        }
        
        self.addButton.snp_makeConstraints { (make) in
            
            make.width.equalTo(buttonW)
            
            make.height.equalTo(buttonH)
            
            make.right.equalTo(-margin)
            
            make.bottom.equalTo(-10)
        }
        
    }
    

    /**
     *	@brief	设置按钮的frame
     *
     *	@return	nil
     */
    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: UITextViewDelegate 代理方法
extension SMComposeToolbar: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        
        let originFrame = self.inputTextView.frame
        
        // 文本框高度
        let _height = self.inputTextView.contentSize.height
        
        if(_height != originFrame.size.height) {
            
            self.height = _height + 12
            
            var changeHeight: CGFloat = 0
            
            if(_height > originFrame.size.height) {
                
                changeHeight = _height - originFrame.size.height
                
                self.y -= changeHeight
            }else {
                
                changeHeight = originFrame.size.height - _height
                
                self.y += changeHeight
            }
            
            UIView.animateWithDuration(0.5, animations: {
                
                self.updateConstraints()
                
            })
        }
    }
    
    
    // 输入框获取焦点后，隐藏其他视图
    func textViewDidEndEditing(textView: UITextView) {
        
    }
    
    
    // 判断用户是否点击了键盘发送按钮
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let rangeText = text as NSString
        
        let inputText = textView.text as NSString
        
        if(rangeText.isEqualToString("\n")) {  // 点击了发送按钮
            
            if(inputText.isEqualToString("") == false) {    // 输入框当前有数据才需要发送
                
                self.delegate.sendMessage(inputText as String)
                
                textView.text = ""  // 清空输入框
                
                self.textViewDidChange(textView)
            }
            
            return false
        }
        
        return true
    }
}
