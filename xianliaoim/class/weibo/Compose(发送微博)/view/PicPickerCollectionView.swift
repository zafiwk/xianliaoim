//
//  PicPickerCollectionView.swift
//  wk微博
//
//  Created by wangkang on 2018/4/24.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMaegin: CGFloat = 15
class PicPickerCollectionView: UICollectionView {
    var images : [UIImage] = [UIImage](){
        didSet{
            reloadData();
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib();
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIWidth - 4*edgeMaegin)/3.0;
        layout.itemSize = CGSize(width: itemWH, height: itemWH);
        layout.minimumLineSpacing = edgeMaegin
        layout.minimumInteritemSpacing = edgeMaegin
        
        backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell);
        dataSource = self
        contentInset = UIEdgeInsets(top: edgeMaegin, left: edgeMaegin, bottom: 0, right: edgeMaegin)
    }
}
extension PicPickerCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        
        // 2.给cell设置数据
//        cell.backgroundColor = UIColor.red
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count+1
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
