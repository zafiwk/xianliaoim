//
//  HomeViewController.swift
//  wk微博
//
//  Created by wangkang on 2018/4/10.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import Kingfisher
import MJRefresh
class HomeViewController: BaseVC {
    
    
    private lazy var titleBtn :UIButton = {
        let  btn = TitleBtn();
        btn.setTitle("loginName", for: .normal);
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside);
        btn.sizeToFit()
        return  btn;
    }();
    
    private lazy var popoverAnimator:PopoverAnimator = PopoverAnimator{
        [weak self] (presented) ->() in
        self?.titleBtn.isSelected = presented;
    }
    private lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    private lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    private lazy var tipLabel : UILabel = UILabel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.visitoeView?.addRotationAnim();
        
        if !isLogin{
            return;
        }
//        setupNavigationBar();
        
        setupView()
        
        //        loadStatuses();
        setupHeadView();
        
        setupFooterView();
        
        setupTipLabel();
        
        setupNatifications();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tableView?.reloadData();
    }
}

extension HomeViewController{
    
    private func setupNavigationBar(){
        //1.设置左侧
        let  leftBtn =  UIButton(imageName: "navigationbar_friendattention" );
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn);
        //2.设置右侧
        let  right =  UIButton(imageName: "navigationbar_pop" );
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: right);
        //3.设置titleView
//        navigationItem.titleView = titleBtn;
    }
    
    
    @objc private func btnAction( btn: TitleBtn){
        btn.isSelected = !btn.isSelected;
        
        let  vc = PopurVC();
        //设置控制器弹出样式避免底部tabbar被移除
        vc.modalPresentationStyle = .custom;
        vc.transitioningDelegate = popoverAnimator;
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250);
        present(vc, animated: true, completion: nil);
        
        
        
    }
    
    @objc private  func showPhotoBrowser(noti:Notification){
        
        let indexPath = noti.userInfo![ShowPhotoBrowserIndexKey] as! IndexPath
        let picURLs = noti.userInfo![ShowPhotoBrowserUrlsKey] as! [URL]
        let object  = noti.object as! PicCollectionView
        let photoBrowserVC = PhotoBrowserVC(indexPath: indexPath, picURLs: picURLs)
        photoBrowserVC.modalPresentationStyle = .custom;
        //设置转场代理
        photoBrowserVC.transitioningDelegate = photoBrowserAnimator
        
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVC
        
        present(photoBrowserVC, animated: true, completion: nil);
    }
    
}
//MARK: 请求数据
extension HomeViewController{
    private func loadStatuses(_ isNewData : Bool) {
        weak var weakSelf:HomeViewController! = self;
        
        var since_id = 0;
        var max_id = 0;
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }else{
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 :(max_id-1)
        }
        
        NetTools.shareInstance.loadStatuses (since_id, max_id) { (result, error) in
            if error != nil {
                print(error as Any);
                weakSelf.tableView.mj_footer.endRefreshing()
                weakSelf.tableView.mj_header.endRefreshing();
                return
            }
            
            guard let resultArray = result else {
                return
            }
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray{
                let  status = Status.deserialize(from: statusDict)
                let viewModel = StatusViewModel(status: status!)
                tempViewModel.append(viewModel);
                
            }
            if isNewData{
                weakSelf.viewModels = tempViewModel + weakSelf.viewModels
            }else{
                weakSelf.viewModels += tempViewModel;
            }
            
            weakSelf.cacheImage(viewModels: tempViewModel)
        }
        
    }
    
    @objc private func loadMoreStatuses(){
        loadStatuses(false)
    }
    private func cacheImage(viewModels :[StatusViewModel]){
        let  group =  DispatchGroup();
        weak  var weakSelf:HomeViewController! = self
        let downloader = ImageDownloader.default;
        for viewModel in viewModels {
            //            for picURL   in viewModel.picURLs{
            //                group.enter()
            //            }
            //            if viewModel.picURLs.count == 1{
            for picURL in viewModel.picURLs{
                group.enter()
//                let  imageView = UIImageView();
//                imageView.kf.setImage(with: picURL, placeholder: nil, options: [], progressBlock: nil) { (_, _, _, _) in
//                    group.leave()
//                }
                //            }
                 downloader.downloadImage(with: picURL, retrieveImageTask: nil, options: [], progressBlock: nil) { (_, error, _, _) in
                    if error != nil {
                        NSLog("首页图片缓存出现错误\(String(describing: error))")
                    }
                    group.leave()
                }
            
            }
        }
        group.notify(queue: DispatchQueue.main) {
            
            print(weakSelf)
            weakSelf.tableView.mj_header?.endRefreshing();
            
            weakSelf.tableView.mj_footer?.endRefreshing();
            
            weakSelf.showTipLabel(count: viewModels.count);
            weakSelf.tableView.reloadData();
        }
        
    }
    
    @objc private func loadNewStatuses(){
        loadStatuses(true)
    }
    private func  showTipLabel(count : Int){
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条新微博";
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.setY(y: (self.navigationController?.navigationBar.getHeight())!);
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.tipLabel.setY(y: 10)
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        
        // 2.给cell设置数据
        
        // 2.给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        
        return cell
    }
}
extension HomeViewController{
    func setupView(){
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "homeCell");
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 200 ;
        
        
        //        refreshControl = UIRefreshControl()
        //        let  demoView = UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 40));
        //        demoView.backgroundColor =  UIColor.red;
        //        refreshControl?.addSubview(demoView);
        //
        
        
    }
    
    
    private func setupHeadView(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewStatuses))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放就更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        tableView.mj_header=header;
        tableView.mj_header.beginRefreshing();
    }
    private func setupFooterView(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }
    private func setupTipLabel(){
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0);
        
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIWidth, height: 32);
        
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    
    private func  setupNatifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(noti:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }
}




