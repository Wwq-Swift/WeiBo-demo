//
//  WBWebViewController.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/20.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import WebKit

class WBWebViewController: UIViewController {
    
    var urlString: String?
    
    lazy var wkWeb = WKWebView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
            return
        }
        wkWeb.load(URLRequest(url: url))
        view.addSubview(wkWeb)
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
