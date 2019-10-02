//
//  PicCollectionView.swift
//  wk微博
//
//  Created by wangkang on 2018/4/19.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import Kingfisher
class PicCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var picURLs:[URL ] = [URL](){
        didSet{
            self.reloadData();
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(UINib(nibName: "PicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PicCollectionViewCell");
        dataSource = self;
        delegate = self;
    }

}
extension PicCollectionView :UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count;
    }
    
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCollectionViewCell", for: indexPath) as! PicCollectionViewCell;
//        NSLog("picURLs[indexPath.row]:\(picURLs[indexPath.row])");
        cell.imageView.kf.setImage(with: (picURLs[indexPath.row] as Resource));
        
        return cell;
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = [ShowPhotoBrowserIndexKey:indexPath,ShowPhotoBrowserUrlsKey:picURLs] as [String : Any];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo);
    }
}
extension PicCollectionView : AnimatorPresentedDelegate{
    func startRect(indexPath: IndexPath) -> CGRect {
        let  cell = self.cellForItem(at: indexPath)
        let startFrame = self.convert((cell?.frame)!, to: UIApplication.shared.keyWindow)
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        let  picURL  = picURLs[indexPath.item]
        let  image = ImageCache.default.retrieveImageInDiskCache(forKey: picURL.absoluteString);
        
        //2.计算结束收的frame
        let w =  UIWidth
        let h = w/image!.size.width*image!.size.height
        var y:CGFloat = 0.0
        if h > UIHeight{
            y = 0
        }else{
            y = (UIHeight-h)*0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h);
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        let  picURL  = picURLs[indexPath.item]
        let  image = ImageCache.default.retrieveImageInDiskCache(forKey: picURL.absoluteString);
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return  imageView
        
    }
    
    
}
