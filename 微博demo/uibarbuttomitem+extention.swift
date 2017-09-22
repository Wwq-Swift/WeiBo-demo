//
//  navigationItem+extention.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience  init(title: String, normalColor: UIColor, highlightedColor: UIColor, target: Any? , action: Selector, btnWidth: CGFloat = 50) {

        //自定义UIBarButtonItem的过程
        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: btnWidth, height: 30))
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(highlightedColor, for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
}

