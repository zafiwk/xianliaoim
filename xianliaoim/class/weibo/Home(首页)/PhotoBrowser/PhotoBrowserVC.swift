//
//  PhotoBrowserVC.swift
//  wk微博
//
//  Created by wangkang on 2018/4/29.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserVC: UIViewController {

    var indexPath:IndexPath
    var picURLs: [URL]
    
    //MARK:-懒加载属性
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    
    private lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    private lazy var saveBtn: UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    //MARK:-自定义构造函数
    init(indexPath:IndexPath,picURLs:[URL]){
       
        self.indexPath = indexPath;
        self.picURLs = picURLs;
        //固定写法 不是init
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width  += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- 设置UI界面内容
extension PhotoBrowserVC{
    private  func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        collectionView.register(PhotoBrowserVCCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self;
        
        //监听按钮事件
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
    }
    

}

extension PhotoBrowserVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  picURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserVCCell
        
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self;
        return cell
    }
}
//MARK:- 事件监听函数
extension PhotoBrowserVC{
    @objc private func closeBtnClick(){
        dismiss(animated: true, completion: nil);
    }
    @objc private func  saveBtnClick(){
        let  cell = collectionView.visibleCells.first as! PhotoBrowserVCCell
        guard let image = cell.imageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinshSaveingWithError:contextInfo:)), nil)
    }
    @objc private func  image(image:UIImage,didFinshSaveingWithError error:NSError?,contextInfo:AnyObject){
        var showInfo = ""
        if error != nil{
            showInfo = "保存失败"
        }else{
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

extension PhotoBrowserVC : PhotoBorwerVCCellDelegate{
    func imageViewClick() {
        closeBtnClick();
    }
    
}

extension PhotoBrowserVC : AnimatorDismissDelegate{
    func indexPathForDismissView() -> IndexPath {
        let  cell = collectionView.visibleCells.first
        return collectionView.indexPath(for: cell!)!;
    }
    
    func imageViewForDismissView() -> UIImageView {
        let imageView = UIImageView()
        let cell = collectionView.visibleCells.first! as! PhotoBrowserVCCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    
}
