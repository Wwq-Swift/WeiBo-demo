//
//  Date+extention.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/24.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation

//日期格式化 - 不要频繁的释放和创建， 会影响性能
fileprivate let dateFormatter = DateFormatter()

extension Date {
    
    //计算与当前时间偏差的 delta 秒数的日期字符串
    //在swift 中，如果要定义结构体 的类函数 ，使用static修饰静态函数
    static func cz_dateString(dalta: TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: dalta)
        
        //制定日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    
    
    
    //新浪日期专属格式
    static func cz_sinnaDate(string: String) -> Date? {
        
        //制定日期格式
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return dateFormatter.date(from: string)
    }
}
