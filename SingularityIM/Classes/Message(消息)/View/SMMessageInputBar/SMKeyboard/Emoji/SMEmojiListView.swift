//
//  SMEmojiListView.swift
//  SingularityIM
//
//  Created by SinObjectC on 16/5/5.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class SMEmojiListView: UIView {

    var emojis: NSArray? = {
        
        return NSArray()
        
    }()
    
    /** 显示所有表情的UIScrollView */
    var scrollView: UIScrollView!
    
    /** 显示页码的UIPageControl */
    var pageControl: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1. 显示所有表情的UIScrollView
        let scrollView = UIScrollView()
        
        // 滚动条是UIScrollView的子控件
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.pagingEnabled = true
        
        scrollView.delegate = self
        
        self.addSubview(scrollView)
        
        self.scrollView = scrollView
        
        // 2.显示页码的UIPageControl
        let pageControl = UIPageControl()
        
        // 单页的时候自动隐藏UIPageControl
        pageControl.hidesForSinglePage = true
        
        pageControl.numberOfPages = 4
        
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKeyPath: "currentPageImage")
        
        
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKeyPath: "pageImage")
        
        self.addSubview(pageControl)
        
        self.pageControl = pageControl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setDefaultEmojis(emojis: NSArray) {
        
        self.emojis = emojis
    
        self.pageControl.numberOfPages = 4
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1. UIPageControl的frame
        self.pageControl.width = self.width
        
        self.pageControl.height = 35
        
        self.pageControl.y = self.height - self.pageControl.height
        
        // 2. UIScrollView的frame
        self.scrollView.width = self.width
        
        self.scrollView.height = self.pageControl.y
        
        
        // 3/设置UIScrollView内部控件的尺寸
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


extension SMEmojiListView: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.pageControl.currentPage = (Int)(scrollView.contentOffset.x/scrollView.width + 0.5)
        
    }
}