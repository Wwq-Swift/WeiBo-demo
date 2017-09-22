//
//  WBOauthViewController.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/8.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

//通过webView 加载新浪微博授权页面控制器
class WBOauthViewController: UIViewController {
    
    private lazy var wkWebView = WKWebView()
    
    override func loadView() {
        view = wkWebView
        
        view.backgroundColor = UIColor.white
        //禁止滚动
        wkWebView.scrollView.isScrollEnabled = false
        
//        //wkweb 授权代理
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        //设置导航栏
        title = "登入新浪微博"
        //设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", normalColor: .orange, highlightedColor: .black, target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", normalColor: .orange, highlightedColor: .black, target: self, action: #selector(autoFill), btnWidth: 78)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载页面
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        // 1> url确定要访问的资源
        if let url = URL(string: url) {
            // 2> 建立请求
            let request = URLRequest(url: url)
            // 3> 加载请求
            wkWebView.load(request)
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //关闭控制器
    @objc fileprivate func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    //自动填充 - web的注入， 直接通过js修改 （修改本地浏览器中缓存饿页面内容）
    //点击登入按钮，执行 submit（） ，将本地的数据提交给服务器
    @objc private func autoFill() {
        //准备js
        let js = "document.getElementById('userId').value = 'www.631288233@qq.com';" + "document.getElementById('passwd').value = '123';"
        //让web 执行js
        wkWebView.evaluateJavaScript(js, completionHandler: nil)
    }
    

}

extension WBOauthViewController: WKUIDelegate, WKNavigationDelegate {
    

    /// wkwebview 接收到服务器跳转请求
    ///
    /// - Parameters:
    ///   - webView: webView description
    ///   - navigation: navigation description
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        //确认思路
        // 1. 如果请求地址包含 http://baidu.com 加载页面， 否则不加载页面
        if webView.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return
        }
        
        // 2. 从 http://baidu.com 回调的地址中查询 ‘code=’     query就是url中 ？ 之后的所有部分信息
        //  如果存在授权成功
        if webView.url?.query?.hasPrefix("code=") == false {
            print("获得授权骂失败")
        
            //关闭窗口
            close()
            
        }
        
        // 3. 从query中取出授权吗 code   
        let code = webView.url!.query!.substring(from: "code=".endIndex)
        
        WBNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else{
                SVProgressHUD.showInfo(withStatus: "登入成功")
                SVProgressHUD.setMinimumDismissTimeInterval(1)
                // 登入成功跳转页面 通过通知进行跳转 
                //1. 发送通知  (发送通知不关心有没有监听者)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification),object: nil)
                
                //2. 关闭窗口
                self.close()
            }
        }
        
        print(code)
        
        //   如果有，授权成功，否则授权失败
    }
    
    //网页内容开始加载
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        SVProgressHUD.show()
//    }
    //网页准备加载页面
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    //网页内容加载结束
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
}








