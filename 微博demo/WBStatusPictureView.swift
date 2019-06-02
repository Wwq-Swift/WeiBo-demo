//
//  WBStatusPictureView.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/14.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {

    //配图视图的数组
    private var urls: [AnyObject]? {
        didSet {
            //1.隐藏所有的 imageView
            for v in subviews {
                v.isHidden = true
            }

            //2.遍历所有的urls数组，顺序设置图片
            var index = 0
            
            guard let urls = urls else {
                return
            }
            
            for url in urls {
                
                //判断是否是4张图片 (如果是四张图则跳过index = 2 的设置 直接设置3 和 4)
                if urls.count == 4 && index == 2 {
                    index += 1
                }
                //获得索引对应的uiimageview
                let iv = subviews[index] as! UIImageView
                //显示imageView
                iv.isHidden = false
                //设置图像
                iv.cz_setImage(urlString: url["thumbnail_pic"] as? String, placeholderImage: nil)
                
                //判断是否为gif 的url
                if (url["thumbnail_pic"] as? NSString)?.pathExtension == "gif" {
                    iv.subviews[0].isHidden = false
                }else {
                    iv.subviews[0].isHidden = true
                }
                
                index += 1
                
            }
        }
    }
    
    var viewModel: Statuses? {
        didSet{
            var pictures: [AnyObject] = []
            guard let viewModel = viewModel else {
                viewHeight.constant = 0
                return
            }
            
            //判断是否 为转发微博 
            if let retweetedStatus = viewModel.retweeted_status {
                pictures = retweetedStatus.pic_urls ?? []
            } else {
                pictures = viewModel.pic_urls ?? []
            }
            
        
            guard pictures.count != 0 else {
                    viewHeight.constant = 0
                    return
            }
            
            
            urls = pictures
  
            //通过判断图片个数 来设置 picturesView的高度
            switch pictures.count {

            case 1,2,3:
                viewHeight.constant = WBStatusPictureItemWidth + WBStatusPictureViewOutterMargin
                
            case 4,5,6:
                viewHeight.constant = WBStatusPictureItemWidth * 2 + WBStatusPictureViewOutterMargin + WBStatusPictureViewInnerMarin
                
            case 7,8,9:
                viewHeight.constant = WBStatusPictureItemWidth * 3 + WBStatusPictureViewOutterMargin + 2 * WBStatusPictureViewInnerMarin
            default:
                viewHeight.constant = 0
            
            }
        }
    }

    //显示图片View的高度约束
    @IBOutlet weak var viewHeight: NSLayoutConstraint!

    /*
     1.Cell中的所有控件都要提前准备好
     2.设置的时候，根据数据决定是否显示
     3.不要动态创建
     */
    override func awakeFromNib() {
        setupUI()
    }

    //设置view里的图片  (九宫格图片的设置方法)
    func setupUI() {
        
        //设置显示图片view的背景颜色
        backgroundColor = superview?.backgroundColor
        
        //剪切超出view之外的内容
        clipsToBounds = true
        
        let count = 3

        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
        
        for i in 0 ..< count * count {
            
            let iv = UIImageView()
            //设置图像填充模式
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            let row = CGFloat( i / count)
            let col = CGFloat(i % count)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMarin)
            let yOffSet = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMarin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffSet)
         
            self.addSubview(iv)
            
            //设置 imageView 是用户可交互的
            iv.isUserInteractionEnabled = true
            iv.tag = i
            
            //设置手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
            iv.addGestureRecognizer(tapGesture)
 
            
            addGifView(iv: iv)
        }
    }
    
    //添加gif图标
    private func addGifView(iv: UIImageView) {
        let gifImageView = UIImageView(image: #imageLiteral(resourceName: "compose_gifbutton_background_highlighted"))
        iv.addSubview(gifImageView)
        
        //自动布局
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iv.addConstraint(NSLayoutConstraint(item: gifImageView,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: iv,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 0))
        
        iv.addConstraint(NSLayoutConstraint(item: gifImageView,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: iv,
                                            attribute: .right,
                                            multiplier: 1.0,
                                            constant: 0))
    
    }
    
    // MARK: - 点击手势触发的方法
    @objc func tapAction(tap: UITapGestureRecognizer) {
        
    }

}
