//
//  String+extention.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/19.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation

extension String {
    
    //从当前字符串中提取 需要的内容   （使用正则表达式）
    func getSourceString() -> String {
        
        //0. 匹配方案
        let parten = "<a href=\"(.*?)\".*?>(.*?)</a>"
        //1. 创建正则表达式，并且匹配
        guard let regx = try? NSRegularExpression(pattern: parten, options: []), let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) else {
            
            return "手机"
        }
  
        //2. 获取结果
  //      let link = (self as NSString).substring(with: result.rangeAt(1))
        let source = (self as NSString).substring(with: result.rangeAt(2))
        
        return source
    }
}
