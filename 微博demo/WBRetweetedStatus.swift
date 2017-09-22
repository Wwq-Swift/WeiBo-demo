//
//  WBRetweetedStatus.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/15.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation
import ObjectMapper

//被转发微博的详细信息模型
struct WBRetweetedStatus: Mappable {
    
    var text: String?

    //配图数组
    var pic_urls: [AnyObject]?
    
    var username: String? {
        didSet{
            retweetedText = "@" + (username ?? "") + ": " + (text ?? "")
        }
    }
    
    var retweetedText: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        text <- map["text"]
        username <- map["user.screen_name"]
        pic_urls <- map["pic_urls"]
        
    }
}

