//
//  UIImageView+WebImage.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/13.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    /// 隔离 SDWebImage 设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: 站位图像
    ///   - isAvatar: 是否设置头像
    func cz_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self](image, _, _, _) in
            if isAvatar {
                self?.image = self?.image?.cz_avatarImage(size: self?.bounds.size)
                
               
            }
            
        }
    }
}
