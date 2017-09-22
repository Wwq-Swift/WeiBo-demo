//
//  WBStatusListDAL.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/23.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation

//DAL 叫做 Data Access Layer 数据访问层   使命：负责处理数据库和网络数据，给listViewModel 返回微博的【字典数组】
//再调整系统的时候，尽量做最小的话的调整！
class WBStatusListDAL {
    
    /// 从本地属数据活着网络加载数据
    ///
    /// - Parameters:
    ///   - since_id: 下拉刷新 id
    ///   - max_id: 上拉刷新 id
    ///   - completion: 完成回调
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping(_ list: [[String: AnyObject]]?,_ isSuccess: Bool) -> Void) {
        
        //0.获取用户账号
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        
        //1.检查本地数据，如果有直接返回
        let array = WBSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        //判断数组是否为空，没有数组返回的是没有数据的空数组
        if array.count > 0 {
            completion(array, true)
            return
        }
        
        //2.加载网络数据
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            //判断网络请求是否成功
            if !isSuccess {
                completion(nil, false)
                return
            }
            
            //判断数据
            guard let list = list else {
                completion(nil, isSuccess)
                
                return
            }
            
            //3.加载完之后，将网络数据字典，写入数组
            WBSQLiteManager.shared.updateStatus(userId: userId, array: list)
            
            //4.返回网络数据
            completion(list, isSuccess)
        }
    }
}
