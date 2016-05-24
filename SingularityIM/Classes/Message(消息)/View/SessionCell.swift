//
//  SessionCell.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/27.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit
import SnapKit
import IMSingularity_Swift

/** 会话列表单元格 */
class SessionCell: UITableViewCell {
    
    // 数据源
    var session: IMSession! {
        didSet {
            self.setData()
        }
    }
    
    // 头像
    lazy var headPortrait: SMCircleImageView = {
        let iconView = SMCircleImageView()
        return iconView
    }()
    
    // 用户名称
    lazy var userName: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .Left
        nameLabel.contentMode = .Center
        nameLabel.font = UIFont.systemFontOfSize(17)
        return nameLabel
    }()
    
    // 最后的历史消息
    lazy var lastMessage: UILabel = {
        let lastMessageLabel = UILabel()
        lastMessageLabel.contentMode = .Center
        lastMessageLabel.textColor = UIColor.lightGrayColor()
        lastMessageLabel.font = UIFont.systemFontOfSize(14)
        return lastMessageLabel
    }()
    
    // 最后对话时间
    lazy var lastChatTime: UILabel = {
        let time = UILabel()
        time.textColor = UIColor.lightGrayColor()
        time.textAlignment = .Right
        time.font = UIFont.systemFontOfSize(12)
        return time
    }()
    
    //  未读消息条数
    lazy var unreadMessageCount: UILabel = {
        let count = UILabel()
        count.textColor = UIColor.whiteColor()
        count.backgroundColor = MessageCountBgColor
        count.font = UIFont.systemFontOfSize(12)
        count.textAlignment = .Center
        count.layer.cornerRadius = count.width/2
        count.clipsToBounds = true
        return count
    }()
    
    // 分隔条
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        // 准备UI
        self.prepareUI()
        
        // 布局UI
        self.layoutUI()
    }

    /** 准备UI */
    private func prepareUI() {
        self.contentView.addSubview(self.headPortrait)
        self.contentView.addSubview(self.userName)
        self.contentView.addSubview(self.lastMessage)
        self.contentView.addSubview(self.lastChatTime)
        self.contentView.addSubview(self.unreadMessageCount)
        self.contentView.addSubview(self.separatorView)
    }
    
    /** 绑定数据 */
    private func setData() {
        // 头像
        self.headPortrait.sd_setImageWithURL(NSURL(string: self.session.target_picture! as String), placeholderImage: UIImage(named: "PhSix"))
        self.headPortrait.layer.cornerRadius = self.headPortrait.width/2
        self.headPortrait.clipsToBounds = true
        
        // 用户名
        self.userName.text = self.session.target_name
        // 最后的消息记录
        self.lastMessage.text = self.session.last_message
        
        // 设置时间来源
        self.create_at()
        
        // 未读消息
        self.unreadMessageCount.layer.cornerRadius = self.unreadMessageCount.width/2
        let count:Int = (Int)(self.session.message_count!)!
        if(count > 0) {
            self.unreadMessageCount.hidden = false
        }else {
            self.unreadMessageCount.hidden = true
        }
        self.unreadMessageCount.text = "\(count)"
    }
    
    /** 设置时间来源 */
    private func create_at() {
        
        let date = NSDate.timeStampToDate(self.session.last_message_time!)
        if(date.isToday()) {
            self.lastChatTime.text = "\(date.dateWithHM(self.session.last_message_time!))"
        }else if(date.isYesterday()) {
            self.lastChatTime.text = "昨天"
        }else if(date.isLastWeek()) {
            self.lastChatTime.text = "\(date.dayOfWeekString())"
        }else if(date.isThisyear()) {
            self.lastChatTime.text = "\(date.dateWithMD(self.session.last_message_time!))"
        }else {
            self.lastChatTime.text = "\(date.dateWithYear(self.session.last_message_time!))"
        }
    }
    
    /** 布局UI */
    private func layoutUI() {
        // 约束子控件
        self.headPortrait.snp_makeConstraints { (make) in
            make.width.equalTo(55)
            make.height.equalTo(55)
            make.left.equalTo(12)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        self.userName.snp_makeConstraints { (make) in
            make.left.equalTo(self.headPortrait.snp_right).offset(15)
            make.top.equalTo(self.headPortrait.snp_top)
            make.right.equalTo(self.lastChatTime).offset(-10)
            make.height.equalTo(35)
        }
        
        self.lastChatTime.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.userName.snp_centerY)
            make.width.equalTo(55)
            make.right.equalTo(-12)
            make.height.equalTo(self.userName.snp_height)
        }
        
        self.lastMessage.snp_makeConstraints { (make) in
            make.left.equalTo(self.userName.snp_left)
            make.height.equalTo(25)
            make.right.equalTo(self.unreadMessageCount.snp_left).offset(-10)
            make.bottom.equalTo(self.headPortrait.snp_bottom)
        }
        
        self.unreadMessageCount.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.lastMessage.snp_centerY)
            make.right.equalTo(-12)
            make.height.equalTo(18)
            make.width.equalTo(18)
        }
        
        self.separatorView.snp_makeConstraints { (make) in
            make.left.equalTo(self.lastMessage.snp_left)
            make.right.equalTo(0)
            make.height.equalTo(0.3)
            make.bottom.equalTo(0)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
