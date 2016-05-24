//
//  SMTabBarViewController.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/23.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class SMTabBarViewController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置tabbar主题
        self.setTabBarTheme()
        
        addChildVc(SMConversationListController(), title: "消息", imageName: "tabbar_message_center_os7", selectedImageName: "tabbar_message_center_selected_os7")
        
        addChildVc(ContactsViewController(), title: "联系人", imageName: "tabbar_profile_os7", selectedImageName: "tabbar_profile_selected_os7")
        
        addChildVc(SMConversationListController(), title: "动态", imageName: "tabbar_home", selectedImageName: "tabbar_home_selected")

    }
    
    /**
     *	@brief	添加一个子控制器给UITabBar
     *
     *	@param 	UIViewController 	子控制器
     *	@param 	String 	标题
     *	@param 	String 	图标
     *	@param 	String 	选中图标
     *
     *	@return	nil
     */
     private func addChildVc(childVc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        
        // 设置标题  相当于同时设置了tabBarItem.title 和 navigationItem.title
        childVc.title = title
        
        // 设置图标
        childVc.tabBarItem.image = UIImage.imageWith(imageName)
        
        // 设置选中的图标
        var selectedImage = UIImage.imageWith(selectedImageName)
        
        if(!ios7) {
            
            // 声明这张图片用原图，不要渲染
            selectedImage = selectedImage.imageWithRenderingMode(.AlwaysOriginal)
            
        }
        
        childVc.tabBarItem.selectedImage = selectedImage
        
        // 添加tabbar控制器的子控制器
        let nav = SMNavigationController(rootViewController: childVc)
        
        self.addChildViewController(nav)
    }
    
    // 设置tabBar主题
    func setTabBarTheme() {
//        self.tabBar.barTintColor = UIColor.lightGrayColor()
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
