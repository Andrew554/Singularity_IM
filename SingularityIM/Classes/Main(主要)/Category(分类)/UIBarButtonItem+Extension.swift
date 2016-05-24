//
//  UIBarButtonItem+Extension.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

/**
 * 扩展UIBarButtonItem，扩展方法
 *
 **/

public extension UIBarButtonItem {
    
    /** 
      * imageName: 正常状态下的背景图片
      * highImageName: 高亮状态下的背景图片
      *
      **/
    public class func itemWithImageName(imageName: String, highImageName: String, target: AnyObject?, action: Selector) -> UIBarButtonItem{
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
//        button.setBackgroundImage(UIImage(named: highImageName), forState: .Highlighted)
        
        //  设置按钮的尺寸为背景图片的尺寸
        button.size = CGSizeMake(12, 20)
        
        //  监听按钮点击
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    public class func itemWithChatRightBar(leftImageName: String, leftTarget: AnyObject?, leftAction: Selector, rightImageName: String, rightTarget: AnyObject?, rightAction: Selector) -> UIBarButtonItem {
        let rightBar = ChatNavBarRightView(imgName1: leftImageName, imgName2: rightImageName)
        print("item: \(rightBar)")
        
        return UIBarButtonItem(customView: rightBar)
    }
}
