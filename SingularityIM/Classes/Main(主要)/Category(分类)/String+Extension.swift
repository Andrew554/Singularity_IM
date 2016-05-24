//
//  NSString+Extension.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/3/30.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

extension String {
//    /** 根据文字动态计算高度 */
//    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize{
//        var textSize:CGSize!
////        if CGSizeEqualToSize(size, CGSizeZero) {    // 单行
////            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
////            textSize = self.sizeWithAttributes(attributes as? [String : AnyObject])
////        } else {    // 多行
//            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
////            let attributes = NSMutableDictionary(object: font, forKey: NSFontAttributeName)
//            let paragraphStyle = NSMutableParagraphStyle()
//            // 行间距
//            paragraphStyle.lineSpacing = 3
//            paragraphStyle.alignment = .Center
//            let attributes1 = NSMutableDictionary(objects: [font], forKeys: [NSFontAttributeName])
//            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes1 as? [String : AnyObject], context: nil)
//            textSize = stringRect.size
//        NSLog("计算：\(textSize)")
////        }
//        return textSize
//    }
    
    //MARK:获得string内容高度
    
    func stringSizeWith(fontSize:CGFloat,width:CGFloat) -> CGSize{
        
        let font = UIFont.systemFontOfSize(fontSize)
        
        let size = CGSizeMake(width, CGFloat.max)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        
        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size
        
    }

    
    /**
     public var lineSpacing: CGFloat
     public var paragraphSpacing: CGFloat
     public var alignment: NSTextAlignment
     public var firstLineHeadIndent: CGFloat
     public var headIndent: CGFloat
     public var tailIndent: CGFloat
     public var lineBreakMode: NSLineBreakMode
     public var minimumLineHeight: CGFloat
     public var maximumLineHeight: CGFloat
     public var baseWritingDirection: NSWritingDirection
     public var lineHeightMultiple: CGFloat
     public var paragraphSpacingBefore: CGFloat
     public var hyphenationFactor: Float
     @available(iOS 7.0, *)
     public var tabStops: [NSTextTab]!
     @available(iOS 7.0, *)
     public var defaultTabInterval: CGFloat
     @available(iOS 9.0, *)
     public var allowsDefaultTighteningForTruncation: Bool
     
     @available(iOS 9.0, *)
     public func addTabStop(anObject: NSTextTab)
     @available(iOS 9.0, *)
     public func removeTabStop(anObject: NSTextTab)
     
     @available(iOS 9.0, *)
     public func setParagraphStyle(obj: NSParagraphStyle)

     */
}
