//
//  WBNetworkManager.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/23.
//  Copyright © 2017年 王伟奇. All rights reserved.
//2.00ZvJvADWPU7rB4f2573142fnozkmB  uid:2762021357
//https://rm.api.weibo.com/2/remind/unread_count.json

import AFNetworking

enum WBHTTPMethod {
    case GET
    case POST
}

//网络管理工具
class WBNetworkManager: AFHTTPSessionManager {
    
    //静态区／常量／闭包
    //在第一次访问执行闭包，并且将结果保存在shared中   使用了单例模式
    static let shared: WBNetworkManager = {
        //实例化对象
        let instaace = WBNetworkManager()
        //设置相应序列化支持的类型
        instaace.responseSerializer.acceptableContentTypes?.insert("text/plain")
        //返回对象
        return instaace
    }()
    
    //用户账户的懒加载的属性
    lazy var userAccount = WBUserAccount()
    
    //用户登入标记【计算型属性】
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    //专门负责拼接 token 的网络请求方法
    func tokenRequest(method: WBHTTPMethod, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> Void) {
        
        //处理token字典
        //首先判断token是否为空， 如果为空 直接返回nil 程序执行过程中一般token不会为nil
        guard let token = userAccount.access_token else {
            print("没有token")
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),object: nil)
            
            completion(nil, false)
            return
        }
        //判断 参数字典是否存在 ，如果为 nil ，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            //实例化字典
            parameters = [String: AnyObject]()
        }
        
        //设置参数字典，代码在此处一定有值存在 所以要加 ！ 号
        parameters!["access_token"] = token as AnyObject
        
        request(method: method, URLString: URLString, parameters: parameters as AnyObject, completion: completion)
        
    }
    
    
    
    /// 封装 AFN 的 GET／ POST
    ///
    /// - Parameters:
    ///   - method: 请求方式 GET ／ POST
    ///   - URLString: 请求的url
    ///   - parameters: 请求参数
    ///   - completion: 完成回调
    func request(method: WBHTTPMethod, URLString: String, parameters: AnyObject?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> Void) {
        
        //成功的回调
        let success = { (task: URLSessionDataTask, json: Any?) -> Void in
            
            completion(json as AnyObject,true)
        }
        
        //失败的回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            
            //对token过期 请求失败做的相关处理
            if (task?.response as! HTTPURLResponse).statusCode == 403 {
                print("token过期了")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),object: nil)
            }
            
            completion(error as AnyObject, false)
        }
        
        switch method {
        case .GET:
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        case .POST:
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}

