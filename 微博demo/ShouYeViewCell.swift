//
//  ShouYeViewCell.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/13.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

//关于表格的性能优化 
/*
 1. 尽量少计算，所有的需要素材提前计算好
 2.控件上不要设置圆角半径， 所有的图像渲染，都要注意
 3.不要动态创建控件，所有需要的控件，都要提前创建好，在显示的时候，根据数据隐藏／显示
 4.cell 中控件的层次越少越少，数量越少越好
 
 */

/*
 1.Cell中的所有控件都要提前准备好
 2.设置的时候，根据数据决定是否显示
 3.不要动态创建
 */

//微博 Cell 的协议
@objc public protocol ShouYeViewCellDelegate: NSObjectProtocol {
    
    //微博 Cell 选中 URL 自负床
    @objc optional func ShouYeViewCellDidSelectedUrlString(cell: UITableViewCell, urlString: String)
}

class ShouYeViewCell: UITableViewCell, WBLabelDelegate {
    
    //创建代理属性
    weak var delegate: ShouYeViewCellDelegate?
    
    //微博视图模型
    var viewModel: Statuses? {
        didSet {
            //姓名
            nameLabel.text = viewModel?.user?.screen_name
            //微博文本
            statusLabel?.text = viewModel?.text
            //会员图标
            memberIconView.image = viewModel?.user?.memberIcon
            //vip认证图标
            vipIconView.image = viewModel?.user?.vipIcon
            //用户头像
            iconView.cz_setImage(urlString: viewModel?.user?.profile_image_url, placeholderImage: #imageLiteral(resourceName: "avatar_default_big"),  isAvatar: true)
            //底部工具栏
            toolBar.viewModel = viewModel
            //图片集view
            picturesView.viewModel = viewModel
            //微博来源
            sourceLabel.text = viewModel?.source
            //转发微博的正文
            retweetedText?.text = viewModel?.retweeted_status?.retweetedText
            
            timeLabel.text = viewModel?.createdDate?.description
        }
    }
    
    //头像
    @IBOutlet weak var iconView: UIImageView!
    //姓名
    @IBOutlet weak var nameLabel: UILabel!
    //会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    //认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    //微博正文
    @IBOutlet weak var statusLabel: WBLabel!
    //底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!
    //展示图片的视图View
    @IBOutlet weak var picturesView: WBStatusPictureView!
    //转发微博的正文
    @IBOutlet weak var retweetedText: WBLabel?
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置代理
        retweetedText?.labelDelegate = self
        statusLabel.labelDelegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ShouYeViewCell: ShouYeViewCellDelegate {
    
    func labelDidSelectedLinkText(label: WBLabel, text: String) {
        if text.hasPrefix("http://") || text.hasPrefix("https//") {
            print("对了")
            
            //插入 ？ 表示如果代理没有实现协议方法，就什么都不做
            //如果使用 ！ ，代理没有实现协议方法
            delegate?.ShouYeViewCellDidSelectedUrlString?(cell: self, urlString: text)
            
        }
    }
}
