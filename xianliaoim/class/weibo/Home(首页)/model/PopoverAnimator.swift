//
//  PopoverAnimator.swift
//  wk微博
//
//  Created by wangkang on 2018/4/13.
//  Copyright © 2018年 wangkang. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {

    var  isPresented : Bool = false;
    var  presentedFrame:CGRect = CGRect.zero;
    var callBack :((_ presented : Bool)->())?
    
    //如果定义了一个构造函数，但是没有对默认的构造函数init()进行重写，那么自定义的构造函数会覆盖默认的init()构造函数
    init(callBack:@escaping (_ presented : Bool)->()) {
        self.callBack = callBack;
    }
    
}
//自定义转场动画
extension PopoverAnimator :UIViewControllerTransitioningDelegate{
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        let prsentation = WKUIPresentationController(presentedViewController: presented, presenting: presenting);
        
        prsentation.presentedFrame = presentedFrame;
        return prsentation;
    }
    
    //自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true;
        callBack!(isPresented);
        return self ;
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false;
        callBack!(isPresented);
        return self ;
    }
}

extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    // 获取转场动画的执行上下文:可以通过转场上下文获取弹出view和小时view
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented{
            animationForPresenttedView(transitionContext:transitionContext);
        }else{
            animationForDismissedView(transitionContext:transitionContext);
        }
    }
    
    //动画执行时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5;
    }
    
    //自定义弹出动画
    private func animationForPresenttedView(transitionContext: UIViewControllerContextTransitioning){
        //1.获取弹出view对象
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to);
        //2.添加到到容器对象视图中
        transitionContext.containerView.addSubview(presentedView!);
        //3.执行动画
        presentedView?.transform = CGAffineTransform(scaleX: 1.0,y: 0.0);
        //4.设置锚点
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0);
        UIView.animate(withDuration: transitionDuration(using: transitionContext
            ), animations: {
                presentedView?.transform = CGAffineTransform.identity;
        }) { (_) in
            //设置转场动画完成了
            transitionContext.completeTransition(true);
        }
    }
    
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning){
        let  dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from);
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            //如果是0就会立即小时掉设置一个比较小的数字就能有动画效果
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001);
        }) { (_) in
            dismissView?.removeFromSuperview();
            transitionContext.completeTransition(true);
        }
        
    }
}
