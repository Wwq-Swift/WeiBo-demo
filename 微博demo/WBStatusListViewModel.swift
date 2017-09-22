//
//  WBStatusListViewModel.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/7/7.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import Foundation
import ObjectMapper
import SDWebImage

//微博数据列表视图数据模型， 负责微博数据处理
struct Statuses: Mappable {
    
    var id: Int64 = 0
    //微博信息内容
    var text: String!
    // 转发数
    var reposts_count: Int = 0 {
        didSet{
            repostscount = countString(count: reposts_count, defaultStr: "转发")
            updateHeigh()
        }
    }
    var repostscount: String?
    
    // 评论数
    var comments_count: Int = 0 {
        didSet{
            commentscount = countString(count: comments_count, defaultStr: "评论")
        }
    }
    var commentscount: String?
    
    // 点赞数
    var attitudes_count: Int = 0 {
        didSet{
            attitudescount = countString(count: attitudes_count, defaultStr: "点赞")
        }
    }
    var attitudescount: String?
    
    //微博创建时间字符串
    var created_at: String? {
        didSet{
            createdDate = Date.cz_sinnaDate(string: created_at ?? "")
        }
    }

    var createdDate: Date?
    
    //微博来源 （发布微博使用的客户端）
    var source: String? {
        didSet{
            //重新计算来源并且保存   (注意 在didSet中，给本身再赋值，不会调用 didSet )
            source = "来自 " + (source?.getSourceString() ?? "")
        }
    }
    
    //转发相关类
    var retweeted_status: WBRetweetedStatus?
    
    //配图数组
    var pic_urls: [AnyObject]?
    
    //配图视图的大小
    var pictureViewHeight: CGFloat = 300
    
    //cell 行高
    var rowHeight: CGFloat = 0
    
    
    var user: WBUser?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        pic_urls <- map["pic_urls"]
        retweeted_status <- map["retweeted_status"]
        id <- map["id"]
        text <- map["text"]
        user <- map["user"]
        reposts_count <- map["reposts_count"]
        comments_count <- map["comments_count"]
        attitudes_count <- map["attitudes_count"]
        source <- map["source"]
        created_at <- map["created_at"]
        
    }
        
}

// MARK: - 计算行高
extension Statuses {
    
    mutating func updateHeigh() {
        
        //原创微博：顶部分割视图(12) + 间距(12) + 头像的高度(34) + 间距(12) + 正文高度(计算) + 配图视图高度(计算) + 间距(12) + 底部工具栏视图高度(35)
        //转发微博：顶部分割视图(12) + 间距(12) + 头像的高度(34) + 间距(12) + 正文高度(计算) + 间距(12) + 间距(12)+ 转发文本高度(计算) + 配图视图高度(计算) + 间距(12) + 底部工具栏视图高度(35)
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        //正文预期的大小  原创正文字体大小， 转发正文字体大小
        let textLabelSize = CGSize(width: UIScreen.main.bounds.width - 2 * margin, height: CGFloat(MAXFLOAT))
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        //1. 计算顶部高度
        height = 2 * margin + iconHeight + margin
        
        //2. 正文高度
        if let text = text {
            /*  计算多行文本大小 （高度）
             1. 预期尺寸，宽度固定，高度尽量大
             2. 选项，换行文本，统一使用 .usesLineFragmentOrigin
             3. attributes： 指定字体字典
             */
            height += (text as NSString).boundingRect(with: textLabelSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: originalFont], context: nil).height
            
        }
        
        // 3. 判断是否转发微博
        if retweeted_status != nil {
            height += 2 * margin
            
            //转发文本的高度  - 一定用retweetedText ，拼接了 @ 用户名： 微博文字
            if let text = retweeted_status?.retweetedText {
                height += (text as NSString).boundingRect(with: textLabelSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: retweetedFont], context: nil).height
            }
        }
        
        // 4. 配图视图
        pictureViewHeight = calcluPicViewHeight()
        height += pictureViewHeight
        height += margin
       
        // 5. 底部工具栏
        height += toolbarHeight
        
        // 6. 使用属性记录
        rowHeight = height
    }
    
    //计算配图视图的高度
    func calcluPicViewHeight() -> CGFloat {
        var picCount = 0
        if retweeted_status != nil {
            picCount = retweeted_status?.pic_urls?.count ?? 0
        } else {
            picCount = pic_urls?.count ?? 0
        }
        var pictureViewHeight: CGFloat = 0
        switch picCount {
        case 0:
            pictureViewHeight = 0
        case 1,2,3:
            pictureViewHeight = WBStatusPictureItemWidth + WBStatusPictureViewOutterMargin
        case 4,5,6:
            pictureViewHeight = WBStatusPictureViewOutterMargin + WBStatusPictureItemWidth * 2 + WBStatusPictureViewInnerMarin
        case 7,8,9:
            pictureViewHeight = WBStatusPictureItemWidth * 3 + WBStatusPictureViewOutterMargin + 2 * WBStatusPictureViewInnerMarin
        default:
            break
        }
        return pictureViewHeight
    }
}

// MARK: - 加载列表的方法
extension Statuses {
    //加载列表的方法
    static func loadStatus(since_id: Int64, max_id: Int64, completion: @escaping ([Statuses]?) -> Void) {
        
        //让数据访问层加载数据
        WBStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if isSuccess == true {
                
                //字典转模型
                let array = Mapper<Statuses>().mapArray(JSONArray: list!)
                
                //             print(array)
                
                cacheSingleImage(list: array, completion: completion)
                
                //完成回调
                //        completion(array)
                
            } else {
                completion(nil)
                return
            }

        }
        
//        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
//            
//            if isSuccess == true {
//                
//                //字典转模型
//                let array = Mapper<Statuses>().mapArray(JSONArray: list!)
//                
//                //             print(array)
//                
//                cacheSingleImage(list: array, completion: completion)
//                
//                //完成回调
//                //        completion(array)
//                
//            } else {
//                completion(nil)
//                return
//            }
//        }
    }
}

// MARK: -  缓存本次微博数组中单张图片
extension Statuses {
    /// 缓存本次下载的微博数据数组中的单张图片
    ///
    /// - 应该缓存完单张图像，并且修改过配图的大小之后，再调用，才能够表格等比例显示单张图像！
    ///
    /// - Parameter list: 本次下载的视图模型数组
    static func cacheSingleImage(list: [Statuses]?, completion: @escaping ([Statuses]?) -> Void){
        
        //调度组
        let group = DispatchGroup()
        
        //记录数据长度
        var length = 0
        
        guard let list = list else {
            return
        }
        //遍历数组，查找微博数据中有单张图片的，进行缓存
        //option + cmd + 左  折叠代码
        for vm in list {
            
            //1. 判断图片的数量
            if vm.pic_urls?.count != 1 {
                continue
            }
            // 2.代码执行到这  数组中的图片仅有一张
            guard let pic = vm.pic_urls?[0]["thumbnail_pic"] as? String,
                let url = URL(string: pic) else {
                    return
            }
            
            
            //3. 下载图片
            /*
             a。downloadImage 是 SWDWebImage 的核心方法
             b。图像下载完成之后会自动保存在沙盒中，文件路径是 url 的 md5
             c。如果沙盒中意境存在缓存图像，后续使用 SDWebImage 通过 URL 加载图片，都会加载本地的沙盒里的图像
             c1。不会发起网络请求，同时回调方法，同样会回调
             c2. 方法还是同样的方法，调用还是同样的调用，但是内部不会再发起网络请求
             */
            
            // 注意点： 如果要缓存的图片累计很大，要找后台要接口
            
            // A. 入组
            group.enter()
            
            SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil, completed: { (image, imageData, _, _, _, _) in
                
                print("缓存图片的imageData \(String(describing: imageData))")
                length += imageData?.count ?? 0
                
                // B。 出组  - (一定要放在回调的最后一句，并且 是与 入组成对存在)
                group.leave()
                
                //将图片转成二进制数据
                //        if let image = image； let data = UIImagePNGRepresentation(image)
            })
        }
        
        // C, 监听调度组的情况   notify 表示当调度组为空的时候，再执行尾随闭包内容
        group.notify(queue: DispatchQueue.main) {
            print("图片缓存完成 \(length/1024)")
            
            //执行闭包回调   （主要是上面一个方法loadStatus的回调）
            completion(list)
        }
        
    }

}
// MARK: - 给定义一个数字，返回对应的描述结果
extension Statuses {
    /// 给定义一个数字，返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultStr: 默认显示标题
    /// - Returns: 描述结果
    /*
     如果数字 == 0 显示默认标题
     如果数字 超过一万 显示 x.xx万
     如果数字 <10000  直接显示实际数字
     */
    fileprivate func countString(count: Int?, defaultStr: String) -> String {
        guard let count = count else {
            return defaultStr
        }
        
        if count == 0 {
            return defaultStr
        } else if count > 10000{
            return String(format: "%.02f 万", Double(count / 10000))
        } else {
            return count.description
        }
    }

}







