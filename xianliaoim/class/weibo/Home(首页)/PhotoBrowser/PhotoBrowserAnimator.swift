//
//  PhotoBrowserAnimator.swift
//  wk微博
//
//  Created by wangkang on 2018/4/30.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit
protocol AnimatorPresentedDelegate:NSObjectProtocol {
    func startRect(indexPath:IndexPath)-> CGRect
    func endRect(indexPath:IndexPath) -> CGRect
    func imageView(indexPath:IndexPath) ->UIImageView
}

protocol AnimatorDismissDelegate:NSObjectProtocol {
    func indexPathForDismissView() ->IndexPath
    func imageViewForDismissView() ->UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented :Bool = false
    var presentedDelegate : AnimatorPresentedDelegate?
    var dismissDelegate : AnimatorDismissDelegate?
    var indexPath: IndexPath?
    
}
//实现转场代理
extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate{
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = true
        return self
    }
    
    
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = false
        return self
    }
}
//实现转场动画代理
extension PhotoBrowserAnimator:UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissView(transitionContext: transitionContext)
    }
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        guard let presentedDelegate = presentedDelegate,let indexPath = indexPath else{
            return
        }
        //1.取出弹出的View
        let presentView = transitionContext.view(forKey: .to)!
        
        //2.将prensentedView添加到containerView中
        transitionContext.containerView.addSubview(presentView)
        
        //3.获取执行动画的imageView
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        //4.执行动画
        presentView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            presentView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){
        guard let  dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else{
            return
        }
        //1.取出消失的View
        let dismissView = transitionContext.view(forKey: .from)
        dismissView?.removeFromSuperview();
        
        
        //2获取执行动画的imageView
        let imageView = dismissDelegate.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDismissView()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
}

