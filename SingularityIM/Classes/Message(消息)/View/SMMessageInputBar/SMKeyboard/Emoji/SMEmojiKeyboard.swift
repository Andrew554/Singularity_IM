//
//  SMEmojiKeyboard.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/5/5.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class SMEmojiKeyboard: UIView {
    
    /** 表情列表 */
    var listView: SMEmojiListView!
    
    /** 表情工具条 */
    var toolbar: SMEmojiToolbar!
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        self.backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        
        // 1.添加表情列表
        let listView = SMEmojiListView()
        
        self.addSubview(listView)
        
        self.listView = listView
        
        // 2.添加表情工具条
        let toolbar = SMEmojiToolbar()
        
        toolbar.delegate = self
        
        self.addSubview(toolbar)
        
        self.toolbar = toolbar
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 1.设置工具条的frame
        self.toolbar.width = self.width
        
        self.toolbar.height = 35
        
        self.toolbar.y = self.height - self.toolbar.height
        
        // 1.设置表情列表的frame
        self.listView.width = self.width
        
        self.listView.height = self.toolbar.y
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


// MARK: SMEmojiToolbarDelegate 协议方法

extension SMEmojiKeyboard: SMEmojiToolbarDelegate {
    
    func emojiToolbarDidSelectedButton(toolbar: SMEmojiToolbar, emojiType: SMEmtionType) {
        
        self.listView.setDefaultEmojis(NSArray())
    }
}
