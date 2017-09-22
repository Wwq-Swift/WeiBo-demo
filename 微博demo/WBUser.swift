//
//  WBUser.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/13.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation
import ObjectMapper

//微博用户模型
struct WBUser: Mappable {
    
    var id: Int64 = 0
    //用户昵称
    var screen_name: String?
    //用户头像url地址 ， 50*50像素
    var profile_image_url: String?
    //认证类型 0.认证用户 235：企业认证 220:达人
    var verified_type = 0 {
        didSet{
            
            switch verified_type {
            case 0:
                vipIcon = #imageLiteral(resourceName: "avatar_vip")
            case 2,3,5:
                vipIcon = #imageLiteral(resourceName: "avatar_enterprise_vip")
            case 220:
                vipIcon = #imageLiteral(resourceName: "avatar_grassroot")
            default:
                break
            }
        }
    }
    //会员等级
    var mbrank: Int = 0 {
        didSet {
            if mbrank > 0 && mbrank < 7 {
                memberIcon = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    
    //认证图标
    var vipIcon: UIImage?
    //会员图标 - 存储型属性， 计算完以后直接使用（用内存存换）
    var memberIcon: UIImage?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        screen_name <- map["screen_name"]
        profile_image_url <- map["profile_image_url"]
        verified_type <- map["verified_type"]
        mbrank <- map["mbrank"]
    }
    
}
