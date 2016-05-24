//
//  UIImage+Extension.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

/**
 * 扩展UIImage，创建分类方法
 *
 **/

public extension UIImage {
    
    /**
     *	@brief	UIImage的扩展方法：适配不同os版本
     *
     *	@param 	String 	图片名字
     *
     *	@return	UIImage
     */
    public class func imageWith(name: String) -> UIImage {
        var image: UIImage?
        
        if(ios7) { // 处理ios7的情况
            let newName = name.stringByAppendingString("_os7")
            image = UIImage(named: newName)
        }
        
        if (image == nil) {
            image = UIImage(named: name)
        }
        
        return image!
    }
    
    /**!
     *	@brief	中间拉伸图片，保护两边
     *
     *	@param 	String 	<#String description#>
     *
     *	@return	<#return value description#>
     */
    public class func resizedImage(name: String) -> UIImage {

        let image = UIImage.imageWith(name)
        return image.stretchableImageWithLeftCapWidth((Int)(image.size.width * 0.5), topCapHeight: (Int)(image.size.height * 0.5))
    }
    
    /** 缩小图片 */
    public class func originImage(image: UIImage, scaleToSize: CGSize) -> UIImage {
        // 开启图形上下文
        UIGraphicsBeginImageContext(scaleToSize)
        
        image.drawInRect(CGRect(x: 0, y: 0, width: scaleToSize.width, height: scaleToSize.height))
        
        // 获取按照比例修改的图片
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭图形上下文
        UIGraphicsEndImageContext()
        
        // 返回已经改变的图片
        return scaledImage
    }
    
    
    
    /**
     *	@brief	根据图片的宽高比例缩放适应屏幕
     *
     *	@param 	CGSize 	缩小的图片size
     *
     *	@return	适应屏幕的size
     */
    class func sizeWithScreen(size: CGSize) -> CGSize {

        // 宽高比例
        let scale = size.width / size.height
        
        var width: CGFloat = 0
        
        var height: CGFloat = 0
        
        if(size.width > size.height) {    // 宽适应屏幕，高按照比例缩放
            
            width = SMScreenW
            
            height = width / scale
            
        }else { // 高适应屏幕，宽按照比例缩放
            
            height = SMScreenH
            
            width = height * scale
        }
        
        return CGSizeMake(width, height)
        
    }
}
