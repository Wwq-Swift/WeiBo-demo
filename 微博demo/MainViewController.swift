//
//  MainViewController.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//https://www.baidu.com/?code=669b6545b38a8863a2de4c95dc8a12f5
//https://api.weibo.com/oauth2/authorize?client_id=2791880091&redirect_uri=http://www.baidu.com

import UIKit
import SVProgressHUD

class MainViewController: UITabBarController {
    
    //定时器
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNewfeatureViews()
    
        setupTimer()
        
        //设置代理
        delegate = self
        
        //注册通知 (用于监听通知)
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //销毁时钟 (控制器释放的时候)
        timer?.invalidate()
        
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //访客视图 通知的监听方法
    @objc private func userLogin(n: Notification){
        
        print("用户登入通知\(n)")
        //设置延迟时间
        var delay = DispatchTime.now()
        
        //判断token是否有值，如果有值，提醒用户重新登入
        if n.object != nil {
            
            SVProgressHUD.showInfo(withStatus: "用户登入已经超时，需要重新登入")
            
            delay = delay + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            //展示登入控制器 通常会和uinavigationcontroller 连用，方便放回
            let nav = UINavigationController(rootViewController: WBOauthViewController())
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
    //在tabbar中间加一个按钮uibutton
    private lazy var composeBtn : UIButton = {
        
        () -> UIButton in // 懒加载本质是闭包,只是将这行省略了
        
        // 初始化按钮
        let composeBtn = UIButton()
        // 设置按钮图片
        composeBtn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        // 设置背景图片
        composeBtn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        
        // 给按钮添加点击事件
        composeBtn.addTarget(self, action: #selector(composeBtnClick), for: UIControl.Event.touchUpInside)
        // 设置按钮的尺寸
        composeBtn.sizeToFit()
        return composeBtn
    }()
    
    // MARK: - 撰写微博
    
    //@objc 允许这个函数在运行时通过oc的消息机制被调用
    @objc private func composeBtnClick() {
        print("电击了我")
        
        // 0. 判断是否登陆
        if !WBNetworkManager.shared.userLogon {
            return
        }

        // 1. 实例化视图 (调用类方法)
        let v = WBComposeTypeView.composeTypeView()
        // 2. 显示视图   - 注意闭包的循环引用
        v.show { [weak v] (clsName) in            //弱引用v 来解决循环引用问题
        
            print(clsName ?? 0)
            
            // 展现撰写微博控制器
            
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String  //得到命名空间
            
            guard let clsName = clsName, let cls = NSClassFromString(namespace + "." + clsName) as? UIViewController.Type else {
                v?.removeFromSuperview()
                return
            }
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            
            //强行更新约束
            nav.view.layoutIfNeeded()
            
            self.present(nav, animated: true, completion: {
                //释放选择撰写类型的视图
                v?.removeFromSuperview()
            })
            
            
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 添加中间按钮
        // 按钮在viewDidLoad中添加,会被系统的BarButtonItem挡住,处理不了事件了
        // viewWillAppear中添加按钮,在系统的BarButtonItem之后添加
                tabBar.addSubview(composeBtn)
                // 设置按钮的位置
                let rect = self.tabBar.frame
        let width = rect.width / CGFloat(children.count)
                composeBtn.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
}

// MARK: - 新特性视图处理
extension MainViewController{
    //设置新特性视图
    fileprivate func setupNewfeatureViews() {
        
        //0. 判断是否登入
        if !WBNetworkManager.shared.userLogon {
            return
        }
        
        //2.如果更新，显示新特性，否则显示欢迎
        let v = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.welcomeView()
        
        //3.添加视图
        v.frame = view.bounds
        
        view.addSubview(v)
    }
    
    ////1.检测版本是否更新  计算属性不会占用存储空间
    var isNewVersion: Bool {
        //1. 去当前的版本号
        let currentVerson = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print(currentVerson)
        
        //2.取保存在 用户偏好 目录中的版本号  (使用本地中的配置文件 本地数据库 UserDefaults.standard)
        let oldVersonID = UserDefaults.standard.object(forKey: "VersonID")
        //3. 将当前的版本号保存
        UserDefaults.standard.set(currentVerson, forKey: "VersonID")
        //4. 返回结果（版本号是否一致）
        return oldVersonID as? String != currentVerson
    }
    
}


// MARK: - UITabBarControllerDelegate
extension MainViewController: UITabBarControllerDelegate{
    
    /// 将要选择tabbaritem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController description
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("将要切换到\(viewController)")
        
        //1> 获取控制器在数组中的索引  转为nsarray 直接获取数组位置 为int类型
        let index = (children as NSArray).index(of: viewController)
        //2> 判断当前索引是首页，同时 index 也是首页 ，重复点击首页的按钮   （selectedIndex 获取当前控制器索引）
        if selectedIndex == 0 && index == selectedIndex{
            print("电击了首页")
            
            //3>让表格滚动到顶部
            //a 获取控制器
            let nav = children[0] as! UINavigationController
            let vc = nav.children[0] as! ShouYeViewController
            //b>滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            

            //4> 刷新数据 增加延迟保证滚动回顶部
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                if self.tabBar.items?[0].badgeValue != nil {
                    vc.updateData()
                }
                //5> 清除tabbar 的 badgeValue  和  app 的图标右上角的提醒数字 applicationIconBadgeNumber
                self.tabBar.items?[0].badgeValue = nil
                UIApplication.shared.applicationIconBadgeNumber = 0
            })
            
            
        }
        return true
    }
}

// MARK: - 时钟相关方法
extension MainViewController{
    //定义时钟
    fileprivate func setupTimer() {
        
        //判断是否登入，如果未登入不启动时钟后续方法，直接return返回
        if !WBNetworkManager.shared.userLogon{
            return
        }
        
        //scheduledTimer默认放在主运行循环的下面（放在当前消息循环下面）
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    //时钟触发方法
    @objc private func updateTimer() {
        WBNetworkManager.shared.unreadCont { (unReadCount) in
            
            print("获取到未读的条数\(unReadCount)")
            //设置 tabBarItem 的 badgeValue (右上角的提醒数字)
            self.tabBar.items?[0].badgeValue = unReadCount > 0 ? "\(unReadCount)" : nil
            
            //设置 app 的图标右上角的提醒数字 applicationIconBadgeNumber，从ios8.0之后要用户授权之后才能够显示
            UIApplication.shared.applicationIconBadgeNumber = unReadCount
        }
    }
}




