//
//  WBNewFeatureView.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/11.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

class WBNewFeatureView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func enterBtnTap(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    class func newFeatureView() -> WBNewFeatureView{
        
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        
        return v
    }
    
    override func awakeFromNib() {
        //添加4个视图
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0 ..< count {
            
            let iv = UIImageView(image:#imageLiteral(resourceName: "ad_Default-Portrait"))
            
            if i == 3 {
                iv.image = #imageLiteral(resourceName: "new_feature_extend_portrait_1")
            }
            // 设置 iv 大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(iv)
        }
        
        //设置按钮高亮的图片 并且隐藏按钮
        enterBtn.setImage(#imageLiteral(resourceName: "new_feature_button_extend_highlighted"), for: .highlighted)
        enterBtn.isHidden = true
        
        // 指定 scrollView 的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false // scrollView 回弹效果 可设置
        scrollView.isPagingEnabled = true // 分页 可设置
        
        scrollView.delegate = self
    }

}

extension WBNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //1. 滚动到最后一页 让视图删除
        let pageId = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        //2. 判断是否为最后一页 最后一页删除本视图
        if pageId == scrollView.subviews.count {
            print("欢迎进入微博")
            self.removeFromSuperview()
        }
        
        //3. 如果是倒数第二页显示按钮
        if pageId == scrollView.subviews.count - 1 {
            enterBtn.isHidden = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1. 一旦开始滚动隐藏按钮
        enterBtn.isHidden = true
        //2. 计算当前偏移量  记得加0.5  偏移一半
        let pageId = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = pageId
        
        //3.分页空间的隐藏
        pageControl.isHidden = (pageId == scrollView.subviews.count)
    }
}
