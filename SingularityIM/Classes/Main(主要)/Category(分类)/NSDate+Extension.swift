//
//  NSDate+Extension.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/4/2.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import Foundation

extension NSDate {
    
    
    /** 年/月/日 2016-03-20 18:24:30 */
    func dateWithYMDHMS() -> String {
        
        let fmt = NSDateFormatter()
        
        fmt.dateStyle = .ShortStyle
        
        fmt.timeStyle = .ShortStyle
        
        // 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        fmt.dateFromString("YYYY-MM-dd HH:mm:ss")
        
        return fmt.stringFromDate(self)
        
    }
    
    
    /** 年/月/日 2016-03-20 18:24:30 */
    func dateFromFormat(fromat: String) -> NSDate {
        
        let fmt = NSDateFormatter()
        
        fmt.dateStyle = .ShortStyle
        
        fmt.timeStyle = .ShortStyle
        
        // 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        fmt.dateFromString(fromat)
        
        let selfStr = fmt.stringFromDate(self)
        
        return fmt.dateFromString(selfStr)!
    }
    
    
    /** 年 2016 */
    func dateWithYear(timeStamp:String) -> String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue/1000
        
        let dfmatter = NSDateFormatter()
        
        dfmatter.dateStyle = .ShortStyle
        
        dfmatter.dateFormat = "YYYY"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.stringFromDate(date)
    }
    
    
    /** 年/月/日 2016-03-20 */
    func dateWithYMD() -> String {
        
        let fmt = NSDateFormatter()
        
        fmt.dateFromString("yyyy-MM-dd")
        
        return fmt.stringFromDate(self)
        
    }
    
    
    /** 月/日 03-20 */
    func dateWithMD(timeStamp:String) -> String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue/1000
        
        let dfmatter = NSDateFormatter()
        
        dfmatter.dateStyle = .ShortStyle
        
        dfmatter.dateFormat = "MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
    
        return dfmatter.stringFromDate(date)
    }
    
    
    /** 时/分 09:35 */
    func dateWithHM(timeStamp:String) -> String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue/1000
        
        let dfmatter = NSDateFormatter()
        
        dfmatter.dateStyle = .ShortStyle
        
        dfmatter.dateFormat = "HH:mm"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.stringFromDate(date)
    }
    
    
    /** 时间--->时间戳 */
    public class func dateToTimeStamp(date: NSDate) -> String {
        
        let timeStr = date.dateWithYMDHMS()
        
        print("当前时间：\(timeStr)")
        
        let dateStamp:NSTimeInterval = date.timeIntervalSince1970
        
        let dateStampStr:Int = Int(dateStamp)
        
        print("时间戳：\(dateStampStr)")
        
        return String(dateStampStr)
    }
    
    
    /** 时间戳--->时间 */
    public class func timeStampToDate(timeStamp:String) -> NSDate {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue/1000
        
        let dfmatter = NSDateFormatter()
        
        dfmatter.dateStyle = .ShortStyle
        
        dfmatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
    
        return date
    }
    
    
    /** 是否为今天 */
    func isToday() -> Bool{
        
        let calendar = NSCalendar.currentCalendar()
        
        let unit: NSCalendarUnit = [.Day, .Month, .Year]
        
        // 获得当前时间的年月日
        let nowCmps: NSDateComponents = calendar.components(unit, fromDate: NSDate())
        
        // 获得self的年月日
        let selfCmps: NSDateComponents = calendar.components(unit, fromDate: self)
        
        return (selfCmps.year == nowCmps.year) &&
               (selfCmps.month == nowCmps.month) &&
               (selfCmps.day == nowCmps.day)
    }
    
    
    /** 是否为昨天 */
    func isYesterday() -> Bool {
        
        let calendar = NSCalendar.currentCalendar()
        
        let unit: NSCalendarUnit = [.Day, .Month, .Year]
        
        // 获得当前时间的年月日
        let nowCmps: NSDateComponents = calendar.components(unit, fromDate: NSDate())
        
        // 获得self的年月日
        let selfCmps: NSDateComponents = calendar.components(unit, fromDate: self)
        
        return (selfCmps.year == nowCmps.year) &&
            (selfCmps.month == nowCmps.month) &&
            ((nowCmps.day - selfCmps.day) == 1)
    }
    
    /** 是否为一周之内 */
    func isLastWeek() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = [.Day]
        
        let cmps = calendar.components(unit, fromDate: self, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
        
        return (cmps.day == 7 || cmps.day < 7)
    }
    
    /** 是否为今年 */
    func isThisyear() -> Bool{
        
        let calendar = NSCalendar.currentCalendar()
        
        let unit: NSCalendarUnit = .Year
        
        // 获得当前时间的年月日
        let nowCmps: NSDateComponents = calendar.components(unit, fromDate: NSDate())
        
        // 获得self的年月日
        let selfCmps: NSDateComponents = calendar.components(unit, fromDate: self)

        return (selfCmps.year == nowCmps.year)
    }
    
    
    /** 对应星期 */
    func dayOfWeek() -> Int {
        
        let interval = self.timeIntervalSince1970
        
        let days = Int(interval / 86400)
        
        return (days - 3) % 7
    }
    
    
    func dayOfWeekString() -> String {
        
        let num = self.dayOfWeek()
        
        var str = "星期一"
            switch num {
            case 0:
                str = "星期天"
            case 1:
                str = "星期一"
            case 2:
                str = "星期二"
            case 3:
                str = "星期三"
            case 4:
                str = "星期四"
            case 5:
                str = "星期五"
            case 6:
                str = "星期六"
            default:
                break
            }
        return str
    }
}