//
//  LoginViewController.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/27.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // 通知对象实例
    var notification: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    // 数据操作实例
    var dataUtil: DataUtil = DataUtil.sharedInstance()
    
    // 账号文本框
    var textField: UITextField!
    
    // 登录按钮
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI布局
        self.init_UI()
    }
    
    
    /** 注册通知 */
    override func viewWillAppear(animated: Bool) {
        
        // 注册登录通知
        notification.addObserver(self, selector: #selector(self.loginResultCallBack(_:)), name: "loginResultNotification", object: nil)
        
        // 注册状态改变的通知
        notification.addObserver(self, selector: #selector(self.stateChangeCallBack(_:)), name: "stateChangeNotification", object: nil)
    }

    
    /** 准备UI */
    func init_UI() {
        
        self.title = "奇点即时通信"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let text = UITextField()
        
        text.frame = CGRectMake(50, 180, SMScreenW - 100, 40)
        
        text.layer.cornerRadius = 5
        
        text.layer.borderWidth = 1
        
        text.layer.borderColor = UIColor.grayColor().CGColor
        
        text.backgroundColor = UIColor.whiteColor()
        
        text.textAlignment = .Center
        
        text.text = "lisi"
        
        self.textField = text
        
        self.view.addSubview(self.textField)
        
        let btn = UIButton(frame: CGRect(x: 50, y: 250, width: SMScreenW - 100, height: 40))
        
        btn.layer.cornerRadius = 3
        
        btn.backgroundColor = UIColor.lightGrayColor()
        
//        btn.setBackgroundImage(UIImage(named: "navigationbar_background"), forState: <#T##UIControlState#>)
        
        btn.setTitle("登  陆", forState: .Normal)
        
        self.button = btn
        
        self.button.enabled = true
        
        self.button.addTarget(self, action: #selector(self.invokeLogin), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.button)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        self.notification.removeObserver(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


// MARK: 事件响应
extension LoginViewController {

    /** 登录方法 */
    func invokeLogin() {
        
        self.button.enabled = false
        
        self.button.backgroundColor = UIColor.brownColor()
        
        let name = self.textField.text!
        
        self.dataUtil.invokeLogin("\(name)", name: "李四", picture: "")
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
}

// MARK: 通知的回调方法
extension LoginViewController {
    
    /** 登录通知回调方法 */
    func loginResultCallBack(notification: NSNotification) {
        print("loginResult: \(notification.userInfo!["result"])")
        let result = notification.userInfo!["result"] as! Bool
        if(result) {
            //            let userInfo: UserInfo = NSUserDefaults.standardUserDefaults().objectForKey("name") as! UserInfo
            let name = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
            
            print("登录人名字: \(name)")
            
            // 更改根视图控制器
//            UIApplication.sharedApplication().keyWindow?.rootViewController = SMTabBarViewController()
            UIApplication.sharedApplication().keyWindow?.rootViewController = SMNavigationController(rootViewController: SMConversationListController())
        }
    }
    
    /** 用户在线状态改变的通知回调方法 */
    func stateChangeCallBack(notification: NSNotification) {
        print("stateChange: \(notification.userInfo!["state"])")
    }
}
