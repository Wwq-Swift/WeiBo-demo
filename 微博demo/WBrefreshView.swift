//
//  WBrefreshView.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

//刷新视图 - 负责相关的 UI 显示和动画
class WBrefreshView: UIView {
    //刷新状态
    /*
     IOS 系统中 UIView 封装了旋转动画
         默认顺时针旋转
         就近原则
         如果想要实现同方向旋转，需要调整一个非常小的数字
     */
    var refreshState: WBrefreshState = .Normal {
        didSet{
            switch refreshState {
            case .Normal:
                
                //恢复状态
                tipICon.isHidden = false
                indicator.stopAnimating()
                
                tipLabel.text = "继续使劲拉..."
                
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipICon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tipLabel.text = "放手刷新..."
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipICon.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 0.001)
                })
            case .WillRefresh:
                tipLabel.text = "正在刷新中..."
                
                //隐藏提示图片
                tipICon.isHidden = true
                
                //显示菊花
                indicator.startAnimating()
            }
        }
    }

    //提示标签
    @IBOutlet weak var tipLabel: UILabel!
    //提示图标
    @IBOutlet weak var tipICon: UIImageView!
    //指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    class func refreshView() -> WBrefreshView{
        let nib = UINib(nibName: "WBrefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WBrefreshView
    }

}
