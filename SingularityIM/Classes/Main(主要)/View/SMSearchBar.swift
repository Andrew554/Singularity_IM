//
//  SMSearchBar.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

// 继承系统控件，封装自定义控件

class SMSearchBar: UITextField {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置背景
        self.background = UIImage.resizedImage("搜索框背景图片")
        
        // 设置内容 -- 垂直居中
        self.contentVerticalAlignment = .Center
        
        // 设置左边显示一个放大镜
        let leftView = UIImageView()
        leftView.image = UIImage.imageWith("放大镜图片")
        // 等同于 leftView.size = leftView.image!.size
        leftView.size = leftView.image!.size
        leftView.width = leftView.image!.size.width
        leftView.height = leftView.image!.size.height
        
        // 设置leftView的内容居中显示
        leftView.contentMode = .Center
        self.leftView = leftView
        
        // 设置左边的view永远显示  --  默认不显示
        self.leftViewMode = .Always
        
        // 设置右边永远显示清除按钮 -- 默认不显示
        self.clearButtonMode = .Always
    }
    
    
    /**
      *	@brief	自定义SearchBar
      *
      *	@return	SMSearchBar
      */
    convenience init() {
        print("ddd")
        self.init(frame: CGRectZero)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
