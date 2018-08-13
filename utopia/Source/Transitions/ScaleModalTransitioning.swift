import Foundation
import UIKit

public final class ScaleModalPresentAC: NSObject, UIViewControllerAnimatedTransitioning {
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return TimeInterval.halfSecond
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let duration = transitionDuration(using: transitionContext)
    
    //check custom ainmation conditions
    guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
      let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let fromSnapshot = fromVC.view.snapshotView() else {
        
      CustomTransitionAnimation.alphaPresent(using: transitionContext, duration: duration)
      return
    }
    
    let containerView = transitionContext.containerView
    containerView.addSubview(fromSnapshot)
    fromSnapshot.frame = fromVC.view.frame
    fromVC.view.isHidden = true
    
    
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    containerView.addSubview(toVC.view)
    toVC.view.layoutIfNeeded()
    toVC.view.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.size.height)
    
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
      
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.8, animations: {
        fromSnapshot.transform = CGAffineTransform(scale: 0.7)
        fromSnapshot.alpha = 0
      })
      
      UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7, animations: {
        toVC.view.transform = CGAffineTransform.identity
      })
      
    }, completion: { _ in
      fromSnapshot.removeFromSuperview()
      fromVC.view.isHidden = false
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}


public final class ScaleModalDismissAC: NSObject, UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return TimeInterval.halfSecond
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let duration = transitionDuration(using: transitionContext)
    
    //check custom ainmation conditions
    guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
      let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
        
        CustomTransitionAnimation.alphaDismiss(using: transitionContext, duration: duration)
        return
    }
    
    let containerView = transitionContext.containerView
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    toVC.view.layoutIfNeeded()
    toVC.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    toVC.view.alpha = 0
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
      
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6, animations: {
        fromVC.view.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.size.height)
      })
      
      UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.6, animations: {
        toVC.view.transform = CGAffineTransform.identity
        toVC.view.alpha = 1
      })
      
    }, completion: { _ in
      fromVC.view.removeFromSuperview()
      fromVC.removeFromParentViewController()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
