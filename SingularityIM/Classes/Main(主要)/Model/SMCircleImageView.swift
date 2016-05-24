//
//  SMCircleImageView.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/15.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit


/**
 *	@brief	自定义圆角ImageView
 */

class SMCircleImageView: UIImageView {

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 设置为圆角
        self.layer.cornerRadius = self.width/2
        
        self.layer.masksToBounds = true
        
    }
    
    
    convenience init() {
        
        self.init(frame: CGRectZero)
    }
    
    
    override init(image: UIImage?) {
        
        super.init(image: image)
        
    }
    
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        
        super.init(image: image, highlightedImage: highlightedImage)
        
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
