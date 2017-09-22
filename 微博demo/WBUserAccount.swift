//
//  WBUserAccount.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/9.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

//用户账户信息
class WBUserAccount: NSObject {
    //访问令牌
    var access_token: String?
    //用户代号
    var uid: String?
    //access_token的生命周期，单位秒数
    ///开发者5年
    //使用者3天
    //var expires_in: TimeInterval = 0
    var expires_in: Int?

    
    //过期日期
    var expiresDate: Date? //= Date(timeIntervalSinceNow: 0.0)
    
    //用户昵称
    var screen_name: String?
    //用户头像  用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    override init() {
        super.init()
        
        //从磁盘加载保存的文件 （json）
        //1> 加载磁盘文件二进制数据， 如果失败直接返回

        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("userAccount.json")
        print(filePath)
        guard let data = NSData(contentsOfFile: filePath),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as! [String: AnyObject]else {
                
                return
        }
        
        
        
        //设置属性值
        access_token = dict["access_token"] as? String
        uid = dict["uid"] as? String
        expiresDate = Date(timeIntervalSinceNow: dict["expires_in"] as! TimeInterval)   //int 转 date
        screen_name = dict["screen_name"] as? String
        avatar_large = dict["avatar_large"] as? String
        
        //判断 token 是否过期
        if  expiresDate?.compare(Date()) != .orderedDescending {
            print("token过期")
            //清空token
            access_token = nil
            uid = nil
            
            //删除账户信息
            _ = try? FileManager.default.removeItem(atPath: filePath)
        }
        
     //   print(dict!["uid"])
    }
    
    //存储的方式有
    //1。 偏好设置  存小的 NSUserDefaults
    //2. 沙盒  （归档，plist，json）
    //3. 数据库 存大的
    //4. 钥匙串 （存小的   会自动加密  使用第三方框架SSKeychain）
    func saveAccount() {
        guard let access_token = access_token, let uid = uid else {
            return
        }
        //1. 字典
        let dict = ["access_token": access_token, "uid": uid, "expiresDate": "\(String(describing: expiresDate!))", "expires_in": expires_in ?? 0, "screen_name": screen_name ?? "昵称", "avatar_large": avatar_large ?? ""] as [String : AnyObject]
        //2. 字典序列化 data
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        
        // 存储路径
     //   let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        //     let filePath = path.appendingPathComponent("userAccount.json")
        
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString;
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("userAccount.json");
       print(filePath)
   
        (data as NSData?)?.write(toFile: filePath, atomically: true)
        
        print(filePath)
    }
    
//    override var description: String {
//        
//    
//    }

}
