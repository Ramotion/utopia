import Foundation
import UIKit

extension UIWindow {
  
  public func switchRootViewController(_ viewController: UIViewController, onSwitchRVC: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    
    guard let previous = rootViewController else {
      rootViewController = viewController
      completion?()
      onSwitchRVC?()
      return
    }
    
    let removePreviousController: () -> Void = {[weak previous] in
      //mpdal controller have strong reference to it presenting controller, to correct memory management we must dismiss it before replace parent controller.
      previous?.dismiss(animated: false, completion: nil)
      previous?.view.removeFromSuperview()
      previous?.removeFromParentViewController()
    }
    
    guard let snapShot: UIView = subviews.last?.snapshotView() else {
      removePreviousController()
      delay(TimeInterval.oneFrame) {
        self.rootViewController = viewController
        onSwitchRVC?()
        completion?()
      }
      return
    }
    
    removePreviousController()
    addSubview(snapShot)
    
    delay(TimeInterval.oneFrame) { //fucking apple! if previous controller is dismissing modal controller it must be in window views hierarchy
      snapShot.removeFromSuperview()
      self.rootViewController = viewController
      
      onSwitchRVC?()
      
      viewController.view.addSubview(snapShot)
      UIView.animate(withDuration: 0.6, animations: {() -> Void in
        snapShot.layer.opacity = 0
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
      }, completion: {(_ finished: Bool) -> Void in
        snapShot.removeFromSuperview()
        completion?()
      })
    }
  }
}
