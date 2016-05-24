//
//  UIResponder+Router.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/17.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

/**
 *  @brief  聊天界面各种点击事件
 */

public enum EventChatCellType: Int {
    /**
     *  删除事件
     */
    case RemoveEvent
    
    /**
     *  @brief  图片点击事件
     */
    case ImageTapedEvent
    
    /**
     *  @brief  头像点击事件
     */
    case HeadTapedEvent
    
    /**
     *  @brief  头像长按事件
     */
    case HeadLongPressEvent
    
    /**
     *  @brief  输入框点击发送消息事件
     */
    case SendMsgEvent
    
    /**
     *  @brief 输入界面，更多界面，选择图片
     */
    case MoreViewPickerImage
}


class UIResponder_Router: UIResponder {

    /**
     *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
     *
     *  @param eventName 发生的事件名称
     *  @param userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
     *
     */
    
    func routerEventWithType(eventType: EventChatCellType, userInfo: NSDictionary) {
        (self.nextResponder() as! UIResponder_Router).routerEventWithType(eventType, userInfo: userInfo)
        
        NSLog("点击路由")
    }
}
