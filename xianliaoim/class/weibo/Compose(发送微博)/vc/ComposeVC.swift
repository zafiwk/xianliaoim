//
//  ComposeVC.swift
//  wk微博
//
//  Created by wangkang on 2018/4/23.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeVC: UIViewController {

    
    @IBOutlet weak var textView: ComposeTextView!
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    private  lazy  var emoticonVC:EmoticonVC = EmoticonVC { [weak self](emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.textView)
        
    }
    
    
    private lazy var  images : [UIImage] = [UIImage]()
    @IBOutlet weak var bottomBtnToolBar: UIToolbar!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    
    @IBOutlet weak var picPickerBtn: UIButton!
    
    @IBOutlet weak var emoticonBtn: UIButton!
    @IBOutlet weak var toolBarBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        
        setupNotifications()
        
        setupBottomToolsBarClick()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        textView.becomeFirstResponder();
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ComposeVC{
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick));
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style:.plain, target: self, action: #selector(sendItemClick));
        navigationItem.rightBarButtonItem?.isEnabled = false;
        
        titleView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 40.0);
        navigationItem.titleView = titleView
    }
    
    
    private func setupNotifications(){
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIResponder.keyboardWillChangeFrameNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick(noti:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil   )
    }
    
    private func setupBottomToolsBarClick(){
        self.picPickerBtn.addTarget(self, action: #selector(picPickerBtnClick), for: .touchUpInside)
        self.emoticonBtn.addTarget(self, action: #selector(emotionBtnClick), for: .touchUpInside)
    }
}
//MARK:- 导航栏按钮事件
extension ComposeVC{
    @objc private func closeItemClick(item:UINavigationItem){
        print("item:\(item)");
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil);
    }
    @objc private  func sendItemClick(){
        
        // 0.键盘退出
        textView.resignFirstResponder()
        
        // 1.获取发送微博的微博正文
        let statusText = textView.getEmoticonString()
        
        // 2.定义回调的闭包
        let finishedCallback = { (isSuccess : Bool) -> () in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: nil)
        }
        if let image = images.first{
            NetTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishedCallback)
        }else{
            NetTools.shareInstance.sendStatus(statusText: statusText, isSuccess: finishedCallback)
        }
        
    }
    @objc private func removePhotoClick(noti:NSNotification){
        guard let image = noti.object as? UIImage else {
            return
        }
        guard let index = images.index(of: image) else {
            return
        }
        images.remove(at: index)
    
        picPickerCollectionView.images = images
    }
    
    @objc private func emotionBtnClick(){
        textView.resignFirstResponder()
        textView.inputView = textView.inputView != nil ? nil :emoticonVC.view
        textView.becomeFirstResponder()
    }
}

//MARK:- UITextView的代理方法
extension ComposeVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder();
    }
}

//Mark:事件监听函数
extension ComposeVC{
    @objc private func keyboardWillChangeFrame(note:Notification){
        let  duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        let margin = UIHeight - y;
        
        toolBarBottom.constant = margin * (-1);
//        self.toolBarBottom.constant = -300;
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded();
           
        }
        NSLog(" bottomBtnToolBar.frame:\( bottomBtnToolBar.frame)");
    }
    
    @objc private func addPhotoClick(){
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        let  ipc = UIImagePickerController();
        
        ipc.sourceType = .photoLibrary
        
        ipc.delegate = self;
        
        present(ipc, animated: true, completion: nil)
    }
    @objc private func picPickerBtnClick(){
        textView.resignFirstResponder();
    
        
        collectionViewHeight.constant = UIHeight * 0.65;
        UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
        }
    }
    
}
//MARK:-UIImagePickerController的代理方法
extension ComposeVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        images.append(image)
        
        picPickerCollectionView.images = images
        
        
        picker.dismiss(animated: true, completion: nil);

        
    }
}
