//
//  AppDelegate.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/21.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var timer: NSTimer!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 创建窗口
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        
        // 设置状态栏主题颜色
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // TabBar主题
        UITabBar.appearance().tintColor = UIColor.orangeColor()    // 前景色
        
        // 导航栏标题字体主题
        if let font = UIFont(name: "Avenir-Light", size: 21.0) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: font
            ]
        }
        
        // 设置根控制器
        self.window?.rootViewController = SMNavigationController(rootViewController: LoginViewController())
        
        self.window?.makeKeyWindow()
        
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
//        print("测试")
//        self.timer = NSTimer(timeInterval: 2.0, target: self, selector: #selector(self.test), userInfo: nil, repeats: true)
//        timer.fire()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

