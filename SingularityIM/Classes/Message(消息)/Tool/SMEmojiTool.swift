//
//  SMEmojiTool.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/5/5.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class SMEmojiTool: NSObject {

    /** 默认表情数组 */
    static var emojis: NSArray?
    
    
    /**
     *	@brief	获取表情数组的方法
     *
     *	@return	表情数组
     */
    class func defaultEmojis() -> NSArray  {
        
        if(emojis == nil) {
            
            let plist = NSBundle.mainBundle().pathForResource("default", ofType: "plist")
            
            self.emojis = NSArray(contentsOfFile: plist!)
            
        }
        
        return self.emojis!
    }
    
}
