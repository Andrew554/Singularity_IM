//
//  Constant.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/17.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit


// 导航条背景颜色

let navigationBarTintColor: UIColor = UIColor(red: 20/255.0, green: 145/255.0, blue: 230/255.0, alpha: 1)
// 声明全局变量
public let ios7: Bool = false

/** 间距 */
public let SMMessageCellInset: CGFloat = 12

/** 屏宽 */
public let SMScreenW: CGFloat = UIScreen.mainScreen().bounds.width

/** 屏高 */
public let SMScreenH: CGFloat = UIScreen.mainScreen().bounds.height

/** 导航条高度 */
public let SMNavigationBarH: CGFloat = 64

/** 消息字体 */
public let SMMessageFont: UIFont = UIFont.systemFontOfSize(15)

/** table背景颜色 */
public let TableBgColor: UIColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)

/** 输入工具栏背景颜色 */
public let InputViewBgColor: UIColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1)

/** 输入文本框白框颜色 */
public let InputTextViewBorderColor: UIColor = UIColor(red: 173/255.0, green: 175/255.0, blue: 179/255.0, alpha: 1)

/** 未读消息背景颜色 */
public let MessageCountBgColor: UIColor = UIColor(red: 247/255.0, green: 76/255.0, blue: 49/255.0, alpha: 1)

/** 最后一条消息和时间字体颜色 */
public let SMGrayColor: UIColor = UIColor(red: 142/255.0, green: 142/255.0, blue: 142/255.0, alpha: 1)

public func SMLog(format: String, _ args: CVarArgType...){
    NSLog("\(format)")
}

// base
public let kWidthHead: CGFloat = 40  //头像宽度
public let kHeightHead: CGFloat = kWidthHead //头像高度
public let kTopHead: CGFloat = 10  //头像离父视图顶部距离
public let kLeadingHead: CGFloat = 10 //对方发送的消息时，头像距离父视图的leading(头像在左边)
public let kTraingHead: CGFloat  = kLeadingHead //自己发送的消息时，头像距离父视图的traing(头像在右边)

public let kOffsetHHeadToBubble: CGFloat = 0 //头像和气泡水平距离

public let kOffsetTopHeadToBubble: CGFloat = 5  //头像和气泡顶部对其间距

public let kReuseIDSeparate = "-" //可重用ID字符串区分符号

public let kImageNameChat_send_nor = "chat_send_nor"
public let kImageNameChat_send_press = "chat_send_press_pic"

public let kImageNameChat_Recieve_nor = "chat_recive_nor"
public let kImageNameChat_Recieve_press = "chat_recive_press_pic"

public let kCellBottomMargin: CGFloat = 10
// 文本
public let kH_OffsetTextWithHead: CGFloat = 20   //水平方向文本和头像的距离
public let kMaxOffsetText: CGFloat = 45   //文本最长时，为了不让文本分行显示，需要和屏幕对面保持一定距离
public let kTop_OffsetTextWithHead: CGFloat = 15     //文本和头像顶部对其间距
public let kBottom_OffsetTextWithSupView: CGFloat = 40   //文本与父视图底部

// 图片
public let kMaxHeightImageView: CGFloat = 100
// 时间
public let kTimeCellReusedID = "time"
// 时间背景
public let kTextColorTime: UIColor = UIColor(red: 0.341, green: 0.369, blue: 0.357, alpha: 1)

public let kTopOffsetTime: CGFloat = 20  //Time Lable和父控件顶部间距
public let kLeadingOffetTime: CGFloat = 20   //Time Lable和父控件左侧最小间距

public let kWidhtHeadImageView = 45

public let kTextColorSubTitle: UIColor = UIColor(red: 0.545, green: 0.545, blue: 0.545, alpha: 1)

public let kBkColorLine: UIColor = UIColor(red: 0.918, green: 0.918, blue: 0.918, alpha: 1)

public let kTextColorTime2: UIColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)

public let kBkColorTableView: UIColor = UIColor(red: 0.773, green: 0.855, blue: 0.824, alpha: 1)

// Voice
public let kHMinOffsetSecondLable_supView: CGFloat = 40  //水平方向上，秒数Lable和父控件之间最小间隙
public let kHOffsetSecondLable_voiceImageView: CGFloat = 10  //水平方向上，秒数Lable和喇叭ImageVIew之间的间隙
public let kHOffsetSecondLable_BubbleView: CGFloat = 20  //水平方向上，秒数Lable和气泡之间的间隙
public let kHOffsetVoiceImage_BubbleView: CGFloat = 25  //水平方向上，喇叭和气泡之间的间隔
public let kVOffsetSecondLable_BubbleView: CGFloat = 20   //垂直方向上，秒数Lable和气泡顶部间隔

public let kTextColorSecondLable_Receive: UIColor = UIColor.blackColor()
public let kTextColorSecondLable_Sender: UIColor =  UIColor.whiteColor()

// 字典字段名
public let kModelKey = "model"


/**
 *	@brief	根据文件名获取沙河路径
 *
 *	@param 	String 	文件名
 *
 *	@return	路径
 */
public func getFilePathByName(fileName: String) -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
    let path = paths[0]
    
    let filePath = (path as NSString).stringByAppendingPathComponent(fileName)
    
    return filePath
    
}

public func getCachePath() -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
    let path = paths[0]
    
    return path
    
}


