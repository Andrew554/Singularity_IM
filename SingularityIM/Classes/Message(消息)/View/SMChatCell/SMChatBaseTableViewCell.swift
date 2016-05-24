//
//  SMChatBaseTableViewCell.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/16.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

import PureLayout
import IMSingularity_Swift


class SMChatBaseTableViewCell: UITableViewCell {

    var cellHeight: CGFloat = 0
    
    var controller: UIViewController!
    
    /**
     *	@brief	头像
     */
    var mHead: UIImageView!

    
    /**
     *	@brief	气泡
     */
    var mBubbleImageView: UIImageView!

    
    /**
     *	@brief	本消息是否是本人发送的
     */
    var isSender: Bool = true

    
    /**
     *	@brief	聊天消息中单条消息模型
     */
    var model: SMMessageFrame!
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.selectionStyle = .None
        
        let image = UIImageView()
        
        image.backgroundColor = UIColor.clearColor()
        
        image.userInteractionEnabled = true
        
        self.mHead = image
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.headBeenTaped(_:)))
        
        self.mHead.addGestureRecognizer(tap)
        
        let headLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.headBeenLongPress(_:)))
        
        self.mHead.addGestureRecognizer(headLongPress)
        
        self.mHead.image = UIImage(named: "user_avatar_default")
        
        self.contentView.addSubview(self.mHead)
        
        let mBubbleImage = UIImageView()
        
        mBubbleImage.backgroundColor = UIColor.clearColor()
        
        mBubbleImage.userInteractionEnabled = true
        
        self.mBubbleImageView = mBubbleImage
        
        let bubbleLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        
        self.mBubbleImageView.addGestureRecognizer(bubbleLongPress)
        
        self.contentView.addSubview(self.mBubbleImageView)
        
    }
    
    
    /**
     *	@brief	设置模型
     *
     *	@param 	MessageCell 	消息单元格
     *
     *	@return
     */
    func set_Model(model: SMMessageFrame) {
        
        self.model = model
        
//        self.mHead.sd_setImageWithURL(NSURL(string: self.model.message.), placeholderImage: <#T##UIImage!#>)
    }
    
    
    /**
     *	@brief	设置ui布局
     *
     *	@return
     */
    func layoutUI() {
        
        self.mHead.frame = self.model.headFrame
        
        switch self.model.alignOrientation {
            
            case .Left:
                
                self.mBubbleImageView.image = UIImage(named: kImageNameChat_Recieve_nor)?.stretchableImageWithLeftCapWidth(30, topCapHeight: 30)
            
                self.mBubbleImageView.highlightedImage = UIImage(named: kImageNameChat_Recieve_press)?.stretchableImageWithLeftCapWidth(30, topCapHeight: 30)
            
            case .Right:
            
                self.mBubbleImageView.image = UIImage(named: kImageNameChat_send_nor)?.stretchableImageWithLeftCapWidth(30, topCapHeight: 30)
                
                self.mBubbleImageView.highlightedImage = UIImage(named: kImageNameChat_send_press)?.stretchableImageWithLeftCapWidth(30, topCapHeight: 30)
            
        }
        
    }

    
    /**
     *	@brief	头像点击手势响应
     *
     *	@param 	UITapGestureRecognizer
     *
     *	@return
     */
    @objc func headBeenTaped(tap: UITapGestureRecognizer) {

        NSLog("点击了头像...")
        
//        (self.nextResponder() as! UIResponder_Router).routerEventWithType(.HeadTapedEvent, userInfo: [kModelKey: self.model])
    }
    
    
    /**
     *	@brief	头像长按手势响应事件
     *
     *	@param 	UILongPressGestureRecognizer
     *
     *	@return
     */
    @objc func headBeenLongPress(press: UILongPressGestureRecognizer) {

        NSLog("长按了头像...")
        
//        (self.nextResponder() as! UIResponder_Router).routerEventWithType(.HeadLongPressEvent, userInfo: [kModelKey: self.model])
    }
    
    
    /**
     *	@brief	气泡被长按后通知，子类必须实现此方法
     *
     *	@param 	Press 长按手势
     *
     *	@return
     */
    @objc func longPress(longPress: UILongPressGestureRecognizer) {

        NSLog("长按气泡...")
        
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
