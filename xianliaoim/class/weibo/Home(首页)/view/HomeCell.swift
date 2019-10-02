//
//  HomeCell.swift
//  wk微博
//
//  Created by wangkang on 2018/4/18.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import Kingfisher
private let edgeMargin : CGFloat = 10
private let itemMargin : CGFloat = 10
class HomeCell: UITableViewCell {

    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var nickname: UILabel!
    
    @IBOutlet weak var mbrankImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var contenLabel: HYLabel!
    
    
//    @IBOutlet weak var zanBtn: UIButton!
//    
//    @IBOutlet weak var commentBtn: UIButton!
//    
//    @IBOutlet weak var forwardBtn: UIButton!
    
    @IBOutlet weak var picView: PicCollectionView!
    
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var retweetedContentLabel: HYLabel!
    
    @IBOutlet weak var bttomValueLayout: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImage.layer.cornerRadius = 20
//        zanBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
//        zanBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10);
//
//        commentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
//        commentBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10);
//
//        forwardBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
//        forwardBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10);
        
        
        
      
        // 设置HYLabel的内容
        contenLabel.matchTextColor = UIColor.purple
        retweetedContentLabel.matchTextColor = UIColor.purple
        
        // 监听HYlabel内容的点击
        // 监听@谁谁谁的点击
        contenLabel.userTapHandler = { (label, user, range) in
            print(user)
            print(range)
        }
        
        // 监听链接的点击
        contenLabel.linkTapHandler = { (label, link, range) in
            print(link)
//            print(range)
            let  url = URL(string: link);
            UIApplication.shared.openURL(url!);
        }
        
        // 监听话题的点击
        contenLabel.topicTapHandler = { (label, topic, range) in
            print(topic)
            print(range)
        }
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            //微博发送人icon
            iconImage.kf.setImage(with: viewModel.profileUrl)
            //微博发送者呢称
            nickname.text = viewModel.status?.user?.screen_name
            //用户等级
            mbrankImage.image = viewModel.vipImage;
            //微博发送时间
            timeLabel.text = viewModel.createAtText;
            //来源
            if let sourceText = viewModel.sourceText{
                sourceLabel.text = "来自 "+sourceText;
            }else{
                sourceLabel.text = nil
            }
            //内容
            contenLabel.text = viewModel.status?.text;
            
            //计算高度和宽度 修改约束
            let  picViewSize = calculatePicViewSize(count: (viewModel.picURLs.count))
            heightLayout.constant = picViewSize.height
            widthLayout.constant = picViewSize.width
            picView.picURLs = viewModel.picURLs;
            
            if viewModel.picURLs.count == 0 {
                bttomValueLayout.constant = 0
            }else{
                bttomValueLayout.constant = 10;
            }
            
            if viewModel.status?.retweeted_status != nil{
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,
                    let retweetedText = viewModel.status?.retweeted_status?.text{
                    retweetedContentLabel.text = "@"+screenName+": "+retweetedText;
                }
                retweetedBgView.isHidden = false
            }else{
                retweetedContentLabel.text = nil
                retweetedBgView.isHidden = true
            }
            
        }
    }
    
}
//MARK: -计算方法
extension HomeCell{
    private func calculatePicViewSize(count : Int) -> CGSize{
        //1.没有配图
        if count == 0{
            return CGSize.zero;
        }
        
        let  layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //2.单张配图
        if count == 1{
            
            
//            let cache  = KingfisherManager.shared.cache;
            //这个对象有删除本地缓存
            let urlString = viewModel?.picURLs.last?.absoluteString;
            
            if let cacheImage = ImageCache.default.retrieveImageInDiskCache(forKey: urlString!) {
                
                if(cacheImage.size.width<UIWidth){
                    layout.itemSize = CGSize(width: (cacheImage.size.width), height: (cacheImage.size.height));
                    return CGSize(width: (cacheImage.size.width), height: (cacheImage.size.height))
                }else{
                    layout.itemSize=CGSize(width: UIWidth-20.0, height: (UIWidth-20.0)/cacheImage.size.width*cacheImage.size.height);
                    return CGSize(width: UIWidth-20.0, height: (UIWidth-20.0)/cacheImage.size.width*cacheImage.size.height);
                }
            }else{
                return CGSize(width: 200, height: 100);
            }
           
        }
        //3.计算出来 imageViewWH
        let imageViewWH = (UIWidth - 2 * edgeMargin - 2 * itemMargin) / 3;
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH);
        
        //4.四张配图
        if count == 4{
            let picViewWH = imageViewWH*2+itemMargin+1
            return CGSize(width: picViewWH, height: picViewWH);
        }
        
        // 7.其他张配图
        // 7.1.计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 7.2.计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        // 7.3.计算picView的宽度
        let picViewW = UIWidth - 2.0 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
