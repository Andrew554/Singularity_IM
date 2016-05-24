//
//  ChatHeadView.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/28.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class ChatHeadView: UIView {
    var name: String = "" {
        willSet {
            print("will Set")
        }
        didSet {
            print("did Set")
            self.nameLabel.text = self.name
            self.layoutUI()
        }
    }
    
    var stateTitle: String = "在线" {
        didSet {
            self.stateLable.text = self.stateTitle
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(17)
        label.textAlignment = .Center
        return label
    }()
    
    private lazy var stateLable: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(10)
        label.textAlignment = .Center
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareUI()
        self.layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    /** 准备UI */
    private func prepareUI() {
        
        self.nameLabel.text = self.name
        self.stateLable.text = self.stateTitle
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.stateLable)
    }
    
    /** 布局UI */
    private func layoutUI() {
        print("layoutUI")
        let attr = [[NSFontAttributeName: self.nameLabel.font], [NSForegroundColorAttributeName: UIColor.whiteColor()]]
        
        let options4: NSStringDrawingOptions = [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading]
        
        let rect = self.name.boundingRectWithSize(CGSizeZero, options: options4, attributes: attr as? [String: AnyObject], context: nil)
        print("rect1 :\(rect)")
       
        self.size = CGSize(width: rect.width + 40, height: rect.height + 30)
        
        NSLog("我是2")
        self.nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(0)
            make.height.equalTo(25)
            make.left.equalTo(5)
            make.right.equalTo(-5)
        }
        self.stateLable.snp_makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp_bottom).offset(5)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }
        print("rect2 :\(self.frame)")
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
