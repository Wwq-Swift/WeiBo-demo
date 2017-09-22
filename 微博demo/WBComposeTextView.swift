//
//  WBComposeTextView.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/21.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
//撰写微博文本视图
class WBComposeTextView: UITextView {

    ///占位符标签
    private lazy var placeholderLabel = UILabel()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    private func setupUI() {
        
        //0.注册监听   监听textView中内容的变化
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
    }
    
    @objc private func textChanged() {
        //如果有文本，占位符隐藏
        placeholderLabel.isHidden = self.hasText
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
