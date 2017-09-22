//
//  WBComposeTypeView.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import pop

//撰写微博类型视图
class WBComposeTypeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    //关闭按钮约束
    @IBOutlet weak var closeBtnCenterX: NSLayoutConstraint!
    //返回前一页按钮约束
    @IBOutlet weak var returnBtnCenterX: NSLayoutConstraint!
    //返回前一页按钮
    @IBOutlet weak var returnBtn: UIButton!
    
    //完成回调
    private var completionBlock: ((_ clsName: String?) -> Void)?
    
    //按钮数组
    fileprivate let buttonsInfo = [ ["image": #imageLiteral(resourceName: "tabbar_compose_idea"), "title": "文字","className": "WBtextComposeViewController"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_photo"), "title": "照片／视频"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_weibo"), "title": "长微博"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_lbs"), "title": "签到"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_review"), "title": "点评"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_more"), "title": "更多", "actionName": "clickMore"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_friend"), "title": "好友圈"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_wbcamera"), "title": "微博相机"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_music"), "title": "音乐"],
                                ["image": #imageLiteral(resourceName: "tabbar_compose_shooting"), "title": "拍摄"]
    ]
    
    //关闭视图
    @IBAction func closeBtnTap(_ sender: UIButton) {
        hideButtons()
      //  removeFromSuperview()
    }
    //返回上一页按钮
    @IBAction func returnBtaTap(_ sender: UIButton) {
        let width = UIScreen.main.bounds.width
        //1.将 scrollview 滚动到第一页\
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        //2. 处理底部按钮  （让两个按钮合并）
        self.closeBtnCenterX.constant -= width / 6
        self.returnBtnCenterX.constant += width / 6
        
        UIView.animate(withDuration: 0.25, animations: { 
            self.layoutIfNeeded()
            self.returnBtn.alpha = 0
        }) { (_) in
            self.returnBtn.isHidden = true
            self.returnBtn.alpha = 1
        }
    }
    
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        //xib 加载默认是 600 * 600
        v.frame = UIScreen.main.bounds
        return v
    }
    
    //显示当前视图
    // oc 中的block 如果当前方法，不能执行，通常使用属性记录，在需要的时候执行
    func show(completion: @escaping (_ clsName: String?) -> Void) {
        
        //0. 记录闭包
        completionBlock = completion
        
        //1> 将当前视图添加到 (根视图控制器)的 View
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }

        //2> 添加视图
        vc.view.addSubview(self)
        
        //3> 开始动画
        showCurrentView()
        
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //功能按钮的事件
    @objc fileprivate func btnTap(selectedButton: WBComposeTypeButton) {
        
        //1. 判断当前显示的视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        //2. 遍历当前视图
        //   - 选中的按钮放大， 未选中的按钮缩小
        for (i, btn) in v.subviews.enumerated() {
            
            
            //1.缩放动画
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            //x,y 在系统中使用cgpoint 表示， 如果要转成 id ，需要使用 “NSvalue” 包装
            let scale: CGFloat = btn == selectedButton ? 2 : 0.2      //根据判断是否为点击的那个按钮来控制  缩放大小
            
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            
            btn.pop_add(scaleAnim, forKey: nil)
            
            //2. 渐变动画  - 动画组
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            //3.监听最后动画
            if i == 0 {
                alphaAnim.completionBlock = { _,_ in
                    //需要执行回调
                    print("完成回调展现控制器")
                    
                    self.completionBlock?(selectedButton.clsName)
                }
            }
            
        }
        
        
    }
    
    //点击更多按钮
    @objc fileprivate func clickMore() {
       
        let width = UIScreen.main.bounds.width
        //1.将 scrollview 滚动到第二页\
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
        
        //2. 处理底部按钮  （让两个按钮分开）
        returnBtn.isHidden = false
        self.closeBtnCenterX.constant += width / 6
        self.returnBtnCenterX.constant -= width / 6
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        
    }

}

// MARK: - 动画方法扩展
fileprivate extension WBComposeTypeView {
    
    // MARK: - 消除部分的动画
    //隐藏按钮的动画
    fileprivate func hideButtons() {
        //1.根据contentOffset 判断当前的子视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        //2.遍历 v 中的所有按钮
        for (i, btn) in v.subviews.enumerated().reversed() {     //reversed() 让它倒序遍历
            
            //1.创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            //2. 设置动画属性
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            //3.添加动画
            btn.pop_add(anim, forKey: nil)
            
            //4. 监听第 0 个按钮的动画，是最后一个执行的
            if i == 0 {
                anim.completionBlock = { _, _ in
                    self.hideCurrentView()
                }
            }
        }
    }
    
    ///隐藏当前视图
    private func hideCurrentView() {
        //1.创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        
        //2. 添加得到视图
        pop_add(anim, forKey: nil)
        
        //3. 添加完成的监听方法
        anim.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 显示部分的动画
    //动画显示当前视图
    fileprivate func showCurrentView() {
        //1> 创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        
        //2>添加到视图
        pop_add(anim, forKey: nil)
        
        //3>添加按钮动画
        showButtons()
    }
    
    //弹力显示所有的按钮
    fileprivate func showButtons() {
        //1. 获取 scrollview 的子视图的第 0 个视图
        let v = scrollView.subviews[0]
        
        //2. 遍历 v 中的所有按钮
        for (i, btn) in v.subviews.enumerated() {
            
            //1> 创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            //2> 设置动画属性
            anim.fromValue = btn.center.y + 350
            anim.toValue = btn.center.y
            
            anim.springBounciness = 8 //设置弹力系数
            anim.springSpeed = 8      //设置弹力速度
            
            //设置动画启动时间 (按钮依次出现)
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            //2>添加动画到按钮
            btn.pop_add(anim, forKey: nil)
            
        }
    }
}


//private 让 extention 中所有的方法都变成私有
private extension WBComposeTypeView {
      func setupUI() {
        //0.强行更新布局
        layoutIfNeeded()
        
        //1. 向scrollView 中添加视图
        let rect = scrollView.bounds
        
        let width = UIScreen.main.bounds.width
        
        for i in 0 ..< 2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            
            //2.向视图中添加按钮
            addBtuutons(v: v, idx: i * 6)
            
            //3.将视图添加到scrollView 中
            scrollView.addSubview(v)
        }
        
        //4.设置 scrollview
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
    }
    
    ///向 v 中添加按钮，按钮的数组索引从 idx 开始
    func addBtuutons(v: UIView, idx: Int) {
        
        let count = 6
        //从idx 开始 添加 6 个按钮
        for i in idx ..< (idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            //0> 获取图像 和 title
            let dict = buttonsInfo[i]
            let image = dict["image"] as! UIImage
            let title = dict["title"] as! String
            //1> 创建按钮
            let btn = WBComposeTypeButton.composeTypeButton(image: image, title: title)
            
            
            //2> 将 btn 添加到视图
            v.addSubview(btn)
            
            //3> 添加监听方法
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName as! String), for: .touchUpInside)
            }else {
                btn.addTarget(self, action: #selector(btnTap(selectedButton:)), for: .touchUpInside)
            }
            
            //4. 设置要展现的类名  注意不需要任何的判断， 有了就设置没有了就不设置
            btn.clsName = dict["className"] as? String
        }
        
        //准备常量
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        //遍历视图的子视图， 布局按钮 (enumerated 可以得到 视图索引 和 子视图 )
        for (i, btn) in v.subviews.enumerated() {
            
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            let y: CGFloat = (i < 3) ? 0 : v.bounds.height - btnSize.height
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
    }
}
