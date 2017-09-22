//
//  WBSQLiteManager.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/23.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation
import FMDB

//最大的数据库缓存时间，以秒为单位
fileprivate let maxDBCacheTime: TimeInterval = -5 * 24 * 60 * 60
/*
    1.数据库本质上是保存在沙盒中的一个文件，首先需要创建并且打开数据库
      FMDB 使用的是队列
    2.创建数据表
    3.增删改查)
 提示： 数据开发，程序代码几乎都是一致的，区别在sql 开发数据库的功能，首先一定要navicat 中测试sql正确性
 */
class WBSQLiteManager {
    
    //单例 全局数据库工具访问点
    static let shared = WBSQLiteManager()
    
    var queue: FMDatabaseQueue?
    
    //构造函数私有 保证了外部无法创建对象 ，保证了单例
    private init() {
        //数据库的全路径 path
        let dbName = "status.db"
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString;
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent(dbName);
        //创建数据库队列，同时 “创建或者打开” 数据库
        queue = FMDatabaseQueue(path: filePath)
        
        //打开数据库
        createTable()
        
        //注册通知 - 监听应用程序进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(clearDBCache), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //清理数据缓存
    //注意细节 SQLite 的数据不断增加数据，数据库文件的大小，会不断的增加
    //如果删除了数据 数据库的大小不会变小
    //如果要变小， 1.备份数据库文件复制一个新的副本，status.db.old 2.新建一个空的数据库文件 3.自己编写sql，从old 中将所有的数据读出，写入新的数据库
    @objc private func clearDBCache() {
        
        let dateString = Date.cz_dateString(dalta: maxDBCacheTime)
        
        print(dateString)
        //准备 sql
        let sql = "DELETE FROM T_Status WHERE creatTimer < ?;"
        
        //执行sql
        queue?.inDatabase({ (db) in
            
            if db?.executeUpdate(sql, withArgumentsIn: [dateString]) == true {
                
            }
        })
    }
    
}

// MARK: - 创建数据表以及其他私有方法
fileprivate extension WBSQLiteManager {
    
 
    
    /// 执行一个SQL ，返回字典的数组
    ///
    /// - Parameter sql: sql
    /// - Returns: 字典数组
    func execRecordSet(sql: String) -> [[String: AnyObject]] {
        
        //结果数组
        var result = [[String: AnyObject]]()
        
        //执行sql  查询数据，不会修改数据，所以不需要开始事物
        //事物的目的，是为了保证数据的有效性，一旦失败，回滚到出事状态
        queue?.inDatabase { (db) in
            guard let rs = db?.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            
            //逐行 - 遍历结果的集合
            while rs.next() {
                
                //1> 列数
                let colCount = rs.columnCount()
                
                //2> 遍历所有的咧
                for col in 0..<colCount {
                    
                    //3> 列名 -》 key //4> 值 -》 value
                    guard let name = rs.columnName(for: col),
                        let value = rs.object(forColumnIndex: col) else {
                            continue
                    }
                    //5> 追加结果
                    result.append([name: value as AnyObject])
                }
                
            }
        }
        
        return result
    }
    
    //创建数据表
    func createTable() {
        //1. 准备SQL
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path) else {
                return
        }
        
        //2.执行sql  FMDB 内部队列是串行队列，同步执行 可以保证统一时间只有一个任务操作数据库
        queue?.inDatabase { (db) in
            
            //只有在创表的时候，使用执行多条语句，剋一次性创建多个数据表
            //在执行增删改查的时候，一定要使用 statements 方法，否则有可能注入
            if db?.executeStatements(sql) == true {
                
            }else {
                
            }
        }
    }
}

// MARK: -
extension WBSQLiteManager {
    
    /// 从数据库加载微博数据数组
    ///
    /// - Parameters:
    ///   - userId: 当前登入的用户账号
    ///   - since_id: 返回id 比 since_id大的微博
    ///   - max_id: 返回ID 比 max_id小的微博
    /// - Returns: 微博的字典数组，将数据库中 status 字段 对应的二进制数据反序列化，生成字典
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: AnyObject]] {
        
        //1. 准备sql
        var sql = "SELECT statusid, userid, status FROM T_Status \n"
        sql += "WHERE userid = \(userId) \n"
        
        //上拉 下拉的判断 ，都是正对统一个 id 进行判断
        if since_id > 0 {
            sql += "AND statusid > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusid < \(max_id) \n"
        }
        
        sql += "ORDER BY statusid DESC LIMIT 20;"
        
        //2. 执行sql
        let array = execRecordSet(sql: sql)
        
        //3.遍历数组，将数组中的status 反序列化，
        var result = [[String: AnyObject]]()
        
        for dict in array {
            
            //反序列化
            guard let jsonData = dict["status"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] else {
                
                continue
            }
            //追加到数组
            result.append(json ?? [:])
        }
        
        
        return result
    }
    
    
    //新增活着修改微博数据，微博数据在刷新的时候，可能出现重叠
    ///
    /// - Parameters:
    ///   - userId: 当前登入的用户 id
    ///   - array: 从网络获取的 字典数组
     func updateStatus(userId: String, array: [[String: AnyObject]]) {
        
        //1. 准备sql
        /*
         statusid: 要保存的微博代号
         userid： 当前登入的用户ID
         status： 完整和你无关微博字典的 json 二进制数据
         */
        let sql = "INSERT OR REPLACE INTO T_Status (statusid, userid, status) VALUES (?, ?, ?);"
        
        //2. 执行Sql
        queue?.inTransaction { (db, rollback) in
            
            //遍历数组, 逐条插入微博数据
            for dict in array {
                
                //从字典获得微博代号 将字典序列化成二进制数据
                guard let statusId = dict["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                
                //执行sql
                if db?.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    
                    //插入失败 需要回滚
                    rollback?.pointee = true
                    
                    break
                    
                }
                
            }
            
        }
    }
    
}































