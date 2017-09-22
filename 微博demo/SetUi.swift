//
//  SetUi.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/23.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation
import UIKit

class SetUi {
    
    ///第一个参数表示哪一个控制器下的uiview  最后一个参数表示哪一个控制器下的uinavigationitem
    class func setVisistorUI(viewIdentity: UIView, lableText: String, iconViewImage: UIImage, centerImage: UIImage = #imageLiteral(resourceName: "visitordiscover_feed_image_house"), houseIconViewIsHidden: Bool, navigationItem: UINavigationItem ) {
        
        ///MARK: - 私有控件
        ///图像视图
        let iconView: UIImageView = UIImageView(image: iconViewImage)
        ///遮罩的背景图片
        let mask: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_mask_smallicon"))
        ///小房子
        let houseIconView: UIImageView = UIImageView(image: centerImage)
        ///提示标签
        let tipLabel: UILabel = UILabel(lableText: lableText, fontSize: 14, tinColor: UIColor.darkGray)
        ///注册按钮
        let registerButton: UIButton = UIButton(title: "注册", normalColor: UIColor.orange, highlightedColor: UIColor.black, backGroundImage: #imageLiteral(resourceName: "common_button_big_white_disable"), fontSize: 16)
        registerButton.addTarget(self, action: #selector(registerBtnTap), for: .touchUpInside)   //添加注册按钮的电击方法
        ///登陆按钮
        let loginButton: UIButton = UIButton(title: "登入", normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backGroundImage: #imageLiteral(resourceName: "common_button_big_white_disable"), fontSize: 16)
        loginButton.addTarget(self, action: #selector(loginBtntap), for: .touchUpInside)
        
        ///设置导航栏上的左边 按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", normalColor: .orange, highlightedColor: .black, target: self, action: #selector(registerBtnTap))
        
        ///设置导航栏上右边的按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登入", normalColor: .orange, highlightedColor: .black, target: self, action: #selector(loginBtntap))
        
        
        //设置遮罩图片大小
        mask.frame = viewIdentity.bounds
        
        viewIdentity.addSubview(iconView)
        viewIdentity.addSubview(mask)
        viewIdentity.addSubview(houseIconView)
        viewIdentity.addSubview(tipLabel)
        viewIdentity.addSubview(registerButton)
        viewIdentity.addSubview(loginButton)
        
        houseIconView.isHidden = houseIconViewIsHidden
        
        //将使用AutoLayout来布局，一定要设置false 不然会崩
        iconView.translatesAutoresizingMaskIntoConstraints = false
        houseIconView.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        //布局相关代码 纯代码布局
        let constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: iconView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: viewIdentity,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: iconView,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: viewIdentity,
                               attribute: .centerY,
                               multiplier: 1.0, constant: -20),
            
            NSLayoutConstraint(item: houseIconView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: iconView,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: houseIconView,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: iconView,
                               attribute: .centerY,
                               multiplier: 1.0,
                               constant: 0),
            
            NSLayoutConstraint(item: tipLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: iconView,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: tipLabel,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: iconView,
                               attribute: .centerY,
                               multiplier: 1.0,
                               constant: (+iconView.frame.height/2+20)),
            NSLayoutConstraint(item: tipLabel,  //设置自己的宽度
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 240),
            
            NSLayoutConstraint(item: registerButton,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: tipLabel,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: -70),
            NSLayoutConstraint(item: registerButton,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: tipLabel,
                               attribute: .centerY,
                               multiplier: 1.0,
                               constant: (+registerButton.frame.width/2+tipLabel.frame.height/2+40)),
            NSLayoutConstraint(item: registerButton,  //设置自己的宽度
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 100),
            NSLayoutConstraint(item: registerButton,  //设置自己的高度
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 40),
            
            NSLayoutConstraint(item: loginButton,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: tipLabel,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: +70),
            NSLayoutConstraint(item: loginButton,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: tipLabel,
                               attribute: .centerY,
                               multiplier: 1.0,
                               constant: (+registerButton.frame.width/2+tipLabel.frame.height/2+40)),
            NSLayoutConstraint(item: loginButton,  //设置自己的宽度
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 100),
            NSLayoutConstraint(item: loginButton,  //设置自己的高度
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 40)
            
        ]
        
        viewIdentity.addConstraints(constraints)
        
        //判断是否是首页的ciconViewImage 是的话添加动画效果
        if iconViewImage == #imageLiteral(resourceName: "visitordiscover_feed_image_smallicon") {
            
            //旋转动画效果 制作过程
            let anim = CABasicAnimation(keyPath: "transform.rotation")
            
            anim.toValue = 2 * Double.pi
            anim.repeatCount = MAXFLOAT
            anim.duration = 15
            
            //动画完成不删除，如果 iconView 被释放，动画会一起被销毁
            //在连续播放动画的非常有用
            anim.isRemovedOnCompletion = false
            
            
            //将动画加入到图层
            iconView.layer.add(anim, forKey: nil)
        }
        
    }
    
    //注册按钮被电击的方法
    @objc class func registerBtnTap() {
        print("注册成功")
    }
    
    //登陆按钮被电击的方法
    @objc class func loginBtntap() {
        print("登陆成功")
        //发送登入通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }

}
