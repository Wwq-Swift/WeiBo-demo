//
//  WBtextComposeViewController.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/19.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import SVProgressHUD
/*
  加载视图控制器的时候，如果 XIB 和控制器同名，默认构造函数，会优先加载 XIB
 */

class WBtextComposeViewController: UIViewController {

    //文本编辑视图
    @IBOutlet weak var textView: UITextView!
    //底部工具栏
    @IBOutlet weak var toolBar: UIToolbar!
    //发布按钮
    @IBOutlet var sendButton: UIButton!
    //标题标签
    @IBOutlet var titleLabel: UILabel!
    //工具栏底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    // MARK: - 按钮监听方法
    //发布微博
    @IBAction func postStatus() {
        //1. 获取微博文字
        let status = textView.text!
        //2. 发布微博
        WBNetworkManager.shared.postStatus(status: status) { (result, isSuccess) in
            
            let message = isSuccess ? "发布成功" : "网络不给力"
            SVProgressHUD.showInfo(withStatus: message)
            
            //判断发布是否成功，如果成功延迟一会关闭窗口
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                    self.exit()
                })
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(n:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //开始键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //关闭键盘
        textView.resignFirstResponder()
    }
    
    // MARK: - 键盘监听方法
    @objc private func keyboardChanged(n: Notification) {
        //1. 目标 rect
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        //2.设置底部约束的高度
        let offSet = view.bounds.height - rect.origin.y
        
        //3.更新底部约束
        toolbarBottomCons.constant = offSet
        
        //4.设置动画
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - UItextViewDelegate
/*
 1.通知一对多  只要有注册的监听者，在注销之前都能监听到通知
 2.代理一对一 ， 只有最后设置的代理有效，会覆盖前面设置的代理
 
    - 代理是发生事件时，直接让代理执行协议方法
      代理效率更高
      直接的反响传值
    - 通知时发生事件时，将通知发送给通知中心，通知中心再 广播 通知
      通知相对于代理效率要低一些
      如果层次嵌套非常深，可以使用通知传值
 */
extension WBtextComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}

fileprivate extension WBtextComposeViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupToolbar()
    }
    
    //设置toolbar
    func setupToolbar() {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background"],
                            ["imageName": "compose_pic_big_add"]]
        
        var items = [UIBarButtonItem]()
        //遍历数组
        for s in itemSettings {
            
            guard let imageName = s["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            
            //追加按钮
            items.append(UIBarButtonItem.init(customView: btn))
            //追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        //删除末尾弹簧
        items.removeLast()
        toolBar.items = items
        
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(exit))
        
        //设置发送按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: sendButton)
        sendButton.isEnabled = false
        navigationItem.titleView = titleLabel
        
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
}
