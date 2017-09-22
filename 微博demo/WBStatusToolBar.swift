//
//  WBStatusToolBar.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/13.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    
    var viewModel: Statuses? {
        didSet{

            retweetedButton.setTitle(viewModel?.repostscount, for: .normal)
            commentButton.setTitle(viewModel?.commentscount, for: .normal)
            likeButton.setTitle(viewModel?.attitudescount, for: .normal)
            
        }
    }
    
    //转发
    @IBOutlet weak var retweetedButton: UIButton!
    //评论
    @IBOutlet weak var commentButton: UIButton!
    //点赞
    @IBOutlet weak var likeButton: UIButton!
    
    
}
