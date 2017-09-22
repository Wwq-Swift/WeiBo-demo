//
//  WBUserShouldLoginNotification.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/8.
//  Copyright © 2017年 王伟奇. All rights reserved.
////https://api.weibo.com/oauth2/authorize?client_id=2791880091&redirect_uri=http://www.baidu.com

import Foundation
import UIKit
// MARK: - 应用程序信息
//应用程序ID
let WBAppKey = "2791880091"
//应用程序加密信息（开发者可以申请修改）
let WBAppSecret = "a078e26c04c8eaecbb34416231feefae"
//回调地址 （登入完成调转的url 参数以get形式拼接）
let WBRedirectURI = "http://www.baidu.com"

// MARK: - 全局通知定义
/// 用户需要登入通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
///用户登入成功通知
let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"


// MARK: - 微博配图视图的常量
//配图视图的外侧间距
let WBStatusPictureViewOutterMargin: CGFloat = 12
//配图视图内部图像视图的间距
let WBStatusPictureViewInnerMarin: CGFloat = 3
//视图内 所有图片合起来的宽度
let WBStatusPictureViewWidth = UIScreen.main.bounds.width - 2 * WBStatusPictureViewOutterMargin
//每个item 的默认宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMarin) / 3
