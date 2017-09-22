//
//  WBWelcomeView.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/11.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    class func welcomeView() -> WBWelcomeView{
        
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //提示 initwithCode 只是刚刚从 xib 的二进制文件将视图数据加载完成
        // 还没有和代码连接建立关系，所以开发时，千万不要在这个方法中处理 UI
    }
    
    override func awakeFromNib() {
        //1. 得到头像url
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large, let url = URL(string: urlString) else{
            return
        }
        
        // 2. 设置头像  （网络加载数据 使用第三方框架 异步加载 SDWebImage）  如果网络图像没有下载完成，先显示占位图像
        iconView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "avatar_default_big"))
    }
    
    //视图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //  layoutIfNeeded() 会直接按照当前的约束直接更新控件位置
        //  执行后，控件位置就是 xib 中的布局位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height/2 + 85
        
        //如果空间的frame 没有计算好， 所有的约束会一起动画
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            
            //更新约束
            self.layoutIfNeeded()
            
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                
                //移除自己视图控制器
                self.removeFromSuperview()
            })
        }
    }
}
