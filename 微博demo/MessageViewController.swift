//
//  MessageViewController.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/19.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //运用三段来判断  是否登入 然后载入相对应的界面   并提取设置visistor界面
        WBNetworkManager.shared.userLogon ? setLoginUI() : setVisistorUI()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLoginUI() {
        
    }
    
    func setVisistorUI() {
        SetUi.setVisistorUI(viewIdentity: self.view, lableText: "登入后，别人评论你的微博，发给你的信息，都会在这里收到通知", iconViewImage: #imageLiteral(resourceName: "visitordiscover_image_message"), houseIconViewIsHidden: true, navigationItem: self.navigationItem)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
