//
//  PhotoBrowserVCCell.swift
//  wk微博
//
//  Created by wangkang on 2018/4/29.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoBorwerVCCellDelegate:NSObjectProtocol {
    func imageViewClick()
}
class PhotoBrowserVCCell: UICollectionViewCell {
    var picURL : URL?{
        didSet{
            setupContent(picURL: picURL)
        }
    }
    var delegate:PhotoBorwerVCCellDelegate?
    //MARK:-懒加载
    private lazy var  scrollView:UIScrollView = UIScrollView()
    private lazy var  progressView:ProgressView = ProgressView()
    lazy var imageView:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK:-设置UI界面
extension PhotoBrowserVCCell{
    private func setupUI(){
        // 1.添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        // 2.设置子控件frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        // 3.设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        // 4.监听imageView的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserVCCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
    }
}
// MARK:- 事件监听
extension PhotoBrowserVCCell {
    @objc private func imageViewClick() {
        delegate?.imageViewClick()
    }
}



extension PhotoBrowserVCCell{
    
    private func setupContent(picURL:URL?){
        guard let picURL = picURL else {
            return
        }
        let image = ImageCache.default.retrieveImageInDiskCache(forKey: picURL.absoluteString)!
        //计算imageView的frame
        let width = UIWidth
        let height = width/image.size.width*image.size.height
        var y:CGFloat = 0
        if height>UIHeight {
            y = 0
        }else{
            y = (UIHeight-height)*0.5
        }
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height);
        
        progressView.isHidden = false
        imageView.kf.setImage(with: getBigURL(smallURL: picURL), placeholder: image, options: [], progressBlock: {[weak self] (current, total) in
            self?.progressView.progress = CGFloat(current) / CGFloat(total)
        }) {[weak self] (_, _, _, _) in
            self?.progressView.isHidden = true;
        }
        scrollView.contentSize = CGSize(width: 0, height: height);
    }
    
    private func getBigURL(smallURL:URL)->URL{
      let smallURLString = smallURL.absoluteString as NSString
        let bigURLString = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigURLString)!;
    }
}
