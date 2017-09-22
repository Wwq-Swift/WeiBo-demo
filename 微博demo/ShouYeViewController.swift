//
//  ShouYeViewController.swift
//  微博demo
//
//  Created by 王伟奇 on 2017/6/17.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit

class ShouYeViewController: UIViewController {
    
    //原创微博cell 的identifierid 
    let originalCellId = "originalCellId"
    //被转发微博cell 的 identifierid
    let retweetedCellId = "retwwtedCellId"
    
    //下拉刷新控件
    var refreshControl: WBrefreshControl?
    
    //数据列表信息
    fileprivate lazy var listViewModel: [Statuses] = []

    var tableView: UITableView?
    
    //下拉刷新的标记
    fileprivate var isPullup: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //运用三段来判断  是否登入 然后载入相对应的界面
        WBNetworkManager.shared.userLogon ? setLoginUI() : setVisistorView()
    
        //监听登入成功与否通知
        NotificationCenter.default.addObserver(self, selector: #selector(setLoginUI), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //释放监听
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - 表格数据源方法，具体的数据源方法实现
extension ShouYeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //0. 取出视图模型， 根据视图模型中的 retweeted 判断是否为转发微博
        let model = listViewModel[indexPath.row]
        let cellId = (model.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        //  cell  本身回调用代理方法（如果有）／如果么有，找到cell，按照自动布局的规则，从上向下计算，找到向下的约束，从而计算动态的行高
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ShouYeViewCell
        
        //给cell的相关属性赋值
        cell.viewModel = model
        
        //设置代理   在首页中自定义的cell 代理
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //1. 根据 indexpath 获取视图模型
        let model = listViewModel[indexPath.row]
        //2. 返回计算好的行高
        return model.rowHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(Int(indexPath.row + 1))
    }
    
    //cell将要出现的时候
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if listViewModel.count == (indexPath.row + 1) && isPullup == false{
            print(indexPath.row + 1)
            isPullup = true
            updateData()
        }
    }
    
    func updateData() {
        if self.isPullup {
            
            //max_id 取出数组中第一条微博的 id
            let max_id = (self.listViewModel.last?.id)! - 1
            //上拉刷新添加数据
            Statuses.loadStatus(since_id: 0, max_id: max_id, completion: { (list) in
                if let lists = list {
                    
                    OperationQueue.main.addOperation {
                        //刷新数据
                        self.listViewModel += lists
                        
                        self.tableView?.reloadData()
                    }
                }else {
                    self.listViewModel += []
                }
            })
            
            
        }else {
            //since_id 取出数组中第一条微博的 id
            let since_id = self.listViewModel.first?.id ?? 0
            //下拉刷新添加数据
            Statuses.loadStatus(since_id: since_id, max_id: 0, completion: { (list) in
                if let lists = list {
                    
                    //添加到主线程操作
                    OperationQueue.main.addOperation {
                        //刷新数据
                        self.listViewModel = lists + self.listViewModel
                        
                        //停止刷新
                    //    self.tableView?.refreshControl?.endRefreshing()
                        self.refreshControl?.endRefreshing()
                        
                        self.isPullup = false
                        
                        self.tableView?.reloadData()
                    }
                }else {
                    self.listViewModel += []
                }
            })
        }
    }
}

// MARK: - Cell 的代理设置 （自己写的代理方法）
extension ShouYeViewController: ShouYeViewCellDelegate {
    func ShouYeViewCellDidSelectedUrlString(cell: UITableViewCell, urlString: String) {
        
        let vc = WBWebViewController()
        vc.urlString = urlString
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - UI相关具体方法
extension ShouYeViewController {
    //添加tableview 并且设置
    func setLoginUI() {
        //清除所有子view
        self.navigationItem.rightBarButtonItem = nil
        for childrenView in view.subviews {
            childrenView.removeFromSuperview()
        }
        
        setupNavTitle()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", normalColor: .darkGray, highlightedColor: .black, target: self, action: #selector(pushFriends))
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 44)
        tableView = UITableView(frame: frame, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        
        //让table继承uitableviewcell
        //  tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //使用xib
        tableView?.register(UINib(nibName: "WBStatusOriginalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
      
        
        
        //设置tableview的行高
        //取消自动行高
  //      tableView?.rowHeight = UITableViewAutomaticDimension
  //      tableView?.estimatedRowHeight = 300   //预估行高
        
        //取消tableView的分割线
        tableView?.separatorStyle = .none
        
        view.insertSubview(tableView!, at: 0)
        
        //下拉刷新的设置 (一种方法是系统自带   另一种自定义的(1.实例化刷新控件，2.添加到表格视图，3.添加监听方法))
//        tableView?.refreshControl = UIRefreshControl()
//        tableView?.refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        refreshControl = WBrefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        //启动时加载数据
        Statuses.loadStatus(since_id: 0, max_id: 0, completion: { (list) in
            if let lists = list {
                
                OperationQueue.main.addOperation {
                    //刷新数据
                    self.listViewModel += lists
                    
                    self.tableView?.reloadData()
                }
            }else {
                self.listViewModel += []
            }
        })
        
        
    }
    
    func pushFriends() {
        performSegue(withIdentifier: "friends", sender: self)
    }
    
    //设置导航栏按钮 中间的一个按钮  （添加一个titleview）
    private func setupNavTitle() {
        //用户昵称获取
        guard let title = WBNetworkManager.shared.userAccount.screen_name else {
            return
        }
        
        let btn = UIButton(title: "\(title) ", normalColor: UIColor.darkGray, highlightedColor: nil, backGroundImage: nil, fontSize: 17)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.setTitleColor(UIColor.black, for: .selected)
        btn.sizeToFit()
        btn.setImage(#imageLiteral(resourceName: "navigationbar_arrow_up"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "navigationbar_arrow_down"), for: .selected)
        //设置button图片的插入位置 (可以设置图片或者label位置)
        btn.imageEdgeInsets.left = btn.frame.width + 26
        self.navigationItem.titleView = btn
        btn.addTarget(self, action: #selector(touchTitleBtn), for: .touchUpInside)
        
    }
    
    @objc private func touchTitleBtn(btn: UIButton) {
        //设置按钮选中状态
        
        btn.isSelected = !btn.isSelected
    }
    
    func setVisistorView() {
        
        SetUi.setVisistorUI(viewIdentity: self.view, lableText: "关注一些人，回这里看看有什么惊喜", iconViewImage: #imageLiteral(resourceName: "visitordiscover_feed_image_smallicon"), centerImage: #imageLiteral(resourceName: "visitordiscover_feed_image_house"), houseIconViewIsHidden: false, navigationItem: self.navigationItem)
    }

}

