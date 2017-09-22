//
//  AppDelegate.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //取得用户授权显示通知【上方提示条／声音／applicationIconBadgeNumber】
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (isSuccess, error) in
            print("授权" + (isSuccess ? "成功" : "失败"))
            
        }
        
        //取得用户授权显示通知【上方提示条／声音／applicationIconBadgeNumber】(ios10.0之前的写法)
//        let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        application.registerUserNotificationSettings(notifySettings)
        
        //apperence api 设置tabbar的颜色  （前景色，背景色，等等）
        UITabBar.appearance().tintColor = UIColor.black
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

