//
//  SMChatVoiceTableViewCell.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/19.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit
import AVFoundation

class SMChatVoiceTableViewCell: SMChatBaseTableViewCell {

    var voiceName: String = ""
    
    /**
     *  @brief  声音秒数Label
     */
    var mSecondLable: UILabel!
    
    
    /**
     *  @brief  喇叭
     */
    var mVoiceImageView: UIImageView!
    
    
    /**
     *	@brief	音频长度
     */
    var mVoiceLength: Int64 = 0

    
    /**
     *	@brief	写数据的文件句柄
     */
    var writeHandle: NSFileHandle!

    
    var _player: AVAudioPlayer?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.voiceBeenTaped(_:)))
            
        self.mBubbleImageView.addGestureRecognizer(tap)
        
        let secondLabel = UILabel()
        
        secondLabel.font = UIFont.systemFontOfSize(13)
        
        secondLabel.backgroundColor = UIColor.clearColor()
        
        self.mSecondLable = secondLabel
        
        self.contentView.addSubview(self.mSecondLable)
        
        let voiceImage = UIImageView()
        
        voiceImage.backgroundColor = UIColor.clearColor()
        
        self.mVoiceImageView = voiceImage
        
        self.contentView.addSubview(self.mVoiceImageView)
    
        self.mVoiceImageView.animationDuration = 1;
        
        self.mVoiceImageView.animationRepeatCount = 0;
        
        // 注册菜单消失的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.uiMenuControllerWillHideMenu), name: UIMenuControllerWillHideMenuNotification, object: nil)

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
    
    
    /**
     *	@brief	设置数据源
     *
     *	@param 	SMMessageFrame
     *
     *	@return
     */
    override func set_Model(model: SMMessageFrame) {

        super.set_Model(model)
        
        self.mSecondLable.text = "\(self.model.voiceLength)'s"
        
        self.layoutUI()
        
        let error = ""
        
        let fileName = NSBundle.mainBundle().pathForResource("没那么简单", ofType: ".mp3")
        
        let url = NSURL(fileURLWithPath: fileName!)
        
        do{
            
            try self._player = AVAudioPlayer(contentsOfURL: url, fileTypeHint: error)
            
        } catch {
            
            print("\(error)")
            
        }
        
        self._player?.prepareToPlay()
    }

    
    /**
     *	@brief	设置ui布局
     *
     *	@return
     */
    override func layoutUI() {

        super.layoutUI()
        
        self.mBubbleImageView.frame = self.model.mBubbleImageViewFrame
        
        let scale: CGFloat = 0.6
        
        let y = self.model.textFrame.minY
        
        let mVoiceImageSize = CGSizeMake(29  * scale, 33 * scale)
        
        let mSecondSize = CGSizeMake(self.model.textFrame.width - mVoiceImageSize.width, mVoiceImageSize.height)
        
        var mVoiceImageX: CGFloat = 0
        
        var mVoiceSecondX: CGFloat = 0
        
        switch self.model.alignOrientation {
            
            case .Right:
            
                self.mSecondLable.textAlignment = .Left
                
                self.mSecondLable.textColor = kTextColorSecondLable_Sender
       
                self.mVoiceImageView.image = UIImage(named: "chat_voice_sender3")
                
                self.mVoiceImageView.animationImages = [UIImage(named: "chat_voice_sender1")!, UIImage(named: "chat_voice_sender2")!, UIImage(named: "chat_voice_sender3")!]
            
                mVoiceImageX = self.model.textFrame.maxX - mVoiceImageSize.width
            
                mVoiceSecondX = self.model.textFrame.minX
            
            case .Left:
                
                self.mSecondLable.textAlignment = .Right
                
                self.mSecondLable.textColor = kTextColorSecondLable_Receive
                
                self.mVoiceImageView.image = UIImage(named: "chat_voice_receive3")
                
                self.mVoiceImageView.animationImages = [UIImage(named: "chat_voice_receive1")!, UIImage(named: "chat_voice_receive2")!, UIImage(named: "chat_voice_receive3")!]
            
                mVoiceImageX = self.model.textFrame.minX
                
                mVoiceSecondX = mVoiceImageX + mVoiceImageSize.width
            
        }
        
        self.mSecondLable.frame = CGRectMake(mVoiceSecondX, y, mSecondSize.width, mSecondSize.height)
        
        self.mVoiceImageView.frame = CGRectMake(mVoiceImageX, y, mVoiceImageSize.width, mVoiceImageSize.height)
        
    }
    

    /**
     *	@brief	点击语音的播放事件
     *
     *	@param 	UITapGestureRecognizer 	手势
     *
     *	@return
     */
    @objc private func voiceBeenTaped(tap: UITapGestureRecognizer) {
        
        self.mVoiceImageView.isAnimating() ? self.stop() : self.play()
        
    }
    
    
    /**
     *	@brief	播放
     *
     *	@return
     */
    private func play() {
        
        self.mVoiceImageView.startAnimating()
        
        self._player?.play()
        
    }
    
 
    /**
     *	@brief	停止播放
     *
     *	@return
     */
    private func stop() {
        
        self.mVoiceImageView.stopAnimating()
        
        self._player?.stop()
        
    }
    
    
    /**
     *	@brief	长按语音
     *
     */
    override func longPress(longPress: UILongPressGestureRecognizer) {
        
        if(longPress.state == UIGestureRecognizerState.Began) {
            
            self.becomeFirstResponder()
            
            self.mBubbleImageView.highlighted = true
            
            let remove = UIMenuItem(title: "删除", action: #selector(self.menuRemove(_:)))
            
            let menu = UIMenuController.sharedMenuController()
            
            menu.menuItems = [remove]
            
            menu.setTargetRect(self.mBubbleImageView.frame, inView: self)
            
            menu.setMenuVisible(true, animated: true)
            
        }
    }
    
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        return (action == #selector(self.menuRemove(_:)))
        
    }

    
    //  MARK: -- 删除
    @objc private func menuRemove(sender: AnyObject) {
        
        NSLog("删除语音")
        
//        (self.nextResponder() as! UIResponder_Router).routerEventWithType(.RemoveEvent, userInfo: [kModelKey: self.model])
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


