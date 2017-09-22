//
//  WBComposeTypeButton.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/18.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //点击按钮要展现控制器的类名
    var clsName: String?

    //使用图像名称 ／ 标题 创建按钮，按钮布局从xib 加载
    class func composeTypeButton(image: UIImage, title: String) -> WBComposeTypeButton {
        
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        
        btn.imageView.image = image
        btn.titleLabel.text = title
        
        return btn
    }
}
