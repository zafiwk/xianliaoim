//
//  EmoticonVC.swift
//  wk微博
//
//  Created by wangkang on 2018/5/1.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

private let EmoticonCell = "EmoticonCell"
class EmoticonVC: UIViewController {

    
    //MARK:-定义属性
    var emoticonCallBack :(_ emoticon:Emoticon)->()
    
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    private lazy var toolBar :UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()
    
    //
    init(emoticonCallBack:@escaping (_ emoticon:Emoticon)->()){
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


}

class EmoticonCollectionViewLayout : UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        let itemWH = UIWidth / 7
        itemSize =  CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        let  insetMargin = ((collectionView?.bounds.height)! - 3 * itemWH)/2.0
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0);
    }
}
extension EmoticonVC{
    private func  setupUI(){
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.purple
//        collectionView.backgroundColor = UIColor.orange
        toolBar.backgroundColor = UIColor.darkGray
        
        //2.设置子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar":toolBar,"cView":collectionView]
        //从左到右
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        //从下到上
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views);
        view.addConstraints(cons)
        
        //准备collectionview
        prepareForCollectionView()
        
        //定义顶部按钮
        prepareForToolBar()
    }
    
    private func prepareForToolBar(){
        let  titles = ["最近","默认","emoji","浪小花"]
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick(item:)))
            item.tag = index
            index += 1
            tempItems.append(item);
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        //设置toolbar的items数组
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    private func prepareForCollectionView(){
        collectionView.register(EmioticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func itemClick(item:UIBarButtonItem){
        // 1.获取点击的item的tag
        let tag = item.tag
        
        // 2.根据tag获取到当前组
        let indexPath = IndexPath(item: 0, section: tag)
        
        // 3.滚动到对应的位置
        collectionView.scrollToItem(at: indexPath , at: .left, animated: true)
    }
}

extension EmoticonVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let section = manager.packages.count
        NSLog("表情键盘section:\(section)")
        return section;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath as IndexPath) as! EmioticonViewCell
        
        // 2.给cell设置数据
//        cell.backgroundColor = UIColor.red
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        //点击后将表情插入到最近分组
        insertRecentlyEmoticon(emoticon: emoticon)
        //将表情回调给外界控制器
        emoticonCallBack(emoticon)
    }
    
    private func  insertRecentlyEmoticon(emoticon:Emoticon){
        if emoticon.isRemove||emoticon.isEmpty{
            return
        }
        if (manager.packages.first?.emoticons.contains(emoticon))!{
            let index = (manager.packages.first?.emoticons.index(of: emoticon))
            manager.packages.first?.emoticons.remove(at: index!)
        }else{
            manager.packages.first?.emoticons.remove(at: 19)
        }
        manager.packages.first?.emoticons.insert(emoticon, at: 0);
    }
}
