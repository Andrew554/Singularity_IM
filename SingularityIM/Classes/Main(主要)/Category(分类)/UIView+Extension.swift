//
//  UIView+Extension.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import Foundation
import UIKit

/**
  * 扩展UIView，创建分类
  *
  * 扩展属性只能是计算属性，扩展不能使用存储属性
  *
  **/
public extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set(x) {
            var frame = self.frame
            frame.origin.x = x
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(y) {
            var frame = self.frame
            frame.origin.y = y
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(width) {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        
        set(height) {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        
        set(size) {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
}
