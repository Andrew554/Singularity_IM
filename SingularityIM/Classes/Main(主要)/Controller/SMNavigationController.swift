//
//  SMNavigationController.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class SMNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // 第一次使用这个类的时候才会调用 -- 一般用于设置主题
    override class func initialize() {
        
        print("initialize")
        
        // 设置UIBarButtonItem的主题
        self.setupBarButtonItemTheme()
        
        // 设置UINavigationBarItem的主题
        self.setupNavigationBarItemTheme()
    }
    
    
    // 设置UIBarButtonItem的主题
    private class func setupBarButtonItemTheme() {
        
    }
    
    
    // 设置UINavigationBarItem的主题
    class func setupNavigationBarItemTheme() {
        
        let appearance = UINavigationBar.appearance()
        
        // 设置导航栏背景
        if(ios7) {
            
        }
        
        appearance.barTintColor = navigationBarTintColor
        
//        appearance.setBackgroundImage(UIImage(named: "send_bg"), forBarMetrics: .Default)
        
        print("setupTheme")
        
        // 设置文字属性
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)]
    }
   
    /**
     *	@brief	拦截所有push进来的子控制器
     *
     *	@param 	UIViewController 	子控制器
     *	@param 	Bool 	动画效果
     *
     *	@return
     */
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if(self.viewControllers.count > 0) { // 如果现在Push的不是栈低控制器（最先进来的那个控制器）
            
            viewController.hidesBottomBarWhenPushed = true
            
            // 设置导航栏按钮
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithImageName("return_Icon", highImageName: "highname", target: self, action: #selector(self.back))
            
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWithImageName("rightButtonName", highImageName: "highName", target: self, action: #selector(self.more))
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    
    /**!
     *	返回上一层
     *
     *	@return
     */
    func back() {
        // 这里用的是self，因为self就是当前正在使用的导航控制器
        self.popViewControllerAnimated(true)
    }
    
    /**! 返回根视图 */
    func more() {
        
        self.popToRootViewControllerAnimated(true)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
