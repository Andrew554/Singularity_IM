//
//  ChatNavBarRightView.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/30.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class ChatNavBarRightView: UIView {
    
    private lazy var callBtn: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .Center
        return button
    }()
    
    private lazy var messBtn: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .Center
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    convenience init(imgName1: String ,imgName2: String) {
        self.init(frame: CGRectZero)
        self.callBtn.setBackgroundImage(UIImage(named: imgName1), forState: .Normal)
        self.messBtn.setBackgroundImage(UIImage(named: imgName2), forState: .Normal)
    }
    
    private func setUpUI() {
        self.size = CGSize(width: 53, height: 35)
       
        self.addSubview(self.callBtn)
        
        self.addSubview(self.messBtn)

        self.layoutUI()
    }
    
    private func layoutUI() {
        self.callBtn.snp_makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(0)
            make.left.equalTo(0)
        }
        
        self.messBtn.snp_makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(0)
            make.width.equalTo(25)
            make.height.equalTo(self.callBtn.snp_height)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
