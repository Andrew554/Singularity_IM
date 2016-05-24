//
//  SMChatTimeTableViewCell.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/17.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

import IMSingularity_Swift


class SMChatTimeTableViewCell: UITableViewCell {
    
    /**
     *	@brief	聊天消息中单条消息模型
     */
    var model: Message!
    
    var mLabel: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.selectionStyle = .None
        
        let label = UILabel.newAutoLayoutView()
        
        label.backgroundColor = UIColor.clearColor()
        
        label.font = UIFont.systemFontOfSize(10)
        
        label.textColor = kTextColorTime
        
        self.mLabel = label
        
        self.contentView.addSubview(self.mLabel)
        
        self.mLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: kTopOffsetTime)
        
        self.mLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        
        self.mLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        
        self.mLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: kLeadingOffetTime, relation: .GreaterThanOrEqual)
    }
    
    
    /**
     *	@brief	设置数据模型
     *
     *	@param 	Message 	消息实体
     *
     *	@return
     */
    func set_model(model: Message) {
        
        self.model = model
        
        self.mLabel.text = NSDate.dateToTimeStamp(NSDate.timeStampToDate(model.message_time!))
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
