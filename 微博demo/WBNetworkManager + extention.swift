//
//  WBNetworkManager + extention.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/23.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension WBNetworkManager {
    
    /// 加载微博的字典数组
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0。
    ///   - completion: 完成回调
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool) -> Void) {
            let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
            let params = ["since_id": "\(since_id)", "max_id": "\(max_id)"]
        
            WBNetworkManager.shared.tokenRequest(method: .GET, URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            
                //从json 中获取 statuses 字典数组
                //如果 as？ 失败  则result = nil
                let result = json?["statuses"] as? [[String: AnyObject]]
                completion(result, isSuccess)
        
            
        }
        
    }
    
    //返回新浪微博的未读数辆的方法
    func unreadCont(completion: @escaping (_ unReadCount: Int) -> ()) {
        guard let uid = userAccount.uid else{
            return
        }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        tokenRequest(method: .GET, URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
          //  print(json)
            guard let json = json else{
                completion(0)
                return
            }
            let count = json["status"]
            completion(count as! Int)
        }
    }

}

// MARK: - 发布微博
extension WBNetworkManager {
    ///发布微博
    /// - Parameter status: 发布微博的内容
    func postStatus(status: String, completion: @escaping (_ result: [String: AnyObject]?, _ isSuccess: Bool) -> ()) -> Void {
        //1. url
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        //2.请求参数
        let params = ["status": status]
        //3.发起网络请求
        tokenRequest(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            
            completion(json as? [String: AnyObject], isSuccess)
        }
    }
}


// MARK: - 获取用户信息
extension WBNetworkManager {
    //加载用户信息  用户登入后立即执行
    func loadUserInfo(completion: @escaping ([String: AnyObject]) -> Void) {
        guard let uid = userAccount.uid else{
            return
        }
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid": uid]
        
        tokenRequest(method: .GET, URLString: urlString, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            //完成回调
            completion(json as? [String : AnyObject] ?? [:])
        }
    }
    
    
}

// MARK: - OAuth相关方法
extension WBNetworkManager {
    
    //加载accesstoken
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,"client_secret": WBAppSecret,"grant_type": "authorization_code","code": code,"redirect_uri": WBRedirectURI]
        
        request(method: .POST, URLString: urlString, parameters: params as AnyObject) { (json, isSuccess) in
            
            guard let json = json, json["access_token"] != nil, json["uid"] != nil, json["expires_in"] != nil else {
                completion(false)
                return
            }
            
   //         print(json)
            //给userAccount 用户设置属性值
            self.userAccount.access_token = (json["access_token"] as! String)
            self.userAccount.uid = (json["uid"] as! String)
            self.userAccount.expires_in = (json["expires_in"] as! Int)
            self.userAccount.expiresDate = Date(timeIntervalSinceNow: json["expires_in"] as! TimeInterval)
         
            
            //加载用户当前信息
            self.loadUserInfo(completion: { (dict) in
        //        print(dict)
                
                self.userAccount.screen_name = dict["screen_name"] as? String
                self.userAccount.avatar_large = dict["avatar_large"] as? String
                
                //保存数据文件
                self.userAccount.saveAccount()
                
                // 用户加载信息完成再 完成回调
                completion(true)
            })
               
            
        }
    }
}


















