//
//  UIKit+extention.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/18.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
extension UIButton {
    convenience  init(title: String, normalColor: UIColor, highlightedColor: UIColor?, backGroundImage: UIImage?,fontSize: CGFloat = 16) {
        
        self.init()
       // self.addTarget(self, action: #selector(), for: .touchUpInside)
        self.setTitle(title, for: .normal)
        self.setTitleColor(normalColor, for: .normal)
        self.setTitleColor(highlightedColor, for: .highlighted)
        self.setBackgroundImage(backGroundImage, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}

extension UILabel {
    convenience init(lableText: String, fontSize: CGFloat, tinColor: UIColor = UIColor.black) {
        self.init()
        self.text = lableText
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.tintColor = tinColor
        self.textAlignment = .center
        
        
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.byCharWrapping  //自动折行
        
        
        self.sizeToFit()
        
    }
}

extension UIImage {
    /// 创建头像图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: backColor的背景颜色
    ///   - lineColor: 边框线颜色
    /// - Returns: 裁剪后的图像
    func cz_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage {
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: .zero, size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result ?? self
        
    }
}
