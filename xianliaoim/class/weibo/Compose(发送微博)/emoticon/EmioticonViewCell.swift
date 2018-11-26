//
//  EmioticonViewCell.swift
//  wk微博
//
//  Created by wangkang on 2018/5/1.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class EmioticonViewCell: UICollectionViewCell {
    //MARK:- 懒加载属性
    private lazy var  emoticonBtn : UIButton = UIButton();
    
    
    var emoticon: Emoticon?{
        didSet{
            guard let emoticon = emoticon else {
                return
            }
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension EmioticonViewCell{
    private func setupUI(){
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
