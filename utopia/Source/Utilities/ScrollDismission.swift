import Foundation
import UIKit


extension UIViewController {
  
  static let pullToDismissThreshold: CGFloat = 60
  
  @discardableResult
  @objc public dynamic func checkDismission(userPanGesture recognizer: UIPanGestureRecognizer) -> Bool {
    let velocity = recognizer.velocity(in: view)
    
    guard
      let scrollView = recognizer.view as? UIScrollView,
      recognizer.state == .ended,
      (scrollView.contentInset.top + scrollView.contentOffset.y) < -UIViewController.pullToDismissThreshold,
      velocity.y > 0
      else { return false }
    
    //disable bounces up scroll view
    scrollView.bounces = false
    scrollView.contentInset.top = -scrollView.contentOffset.y
    scrollView.isUserInteractionEnabled = false
    
    dismissionCallback?()
    dismiss()
    return true
  }
  
  public func setupPullToDismiss() {
    let recognizer = UIPanGestureRecognizer {[weak self] recognizer in
      guard let recognizer = recognizer as? UIPanGestureRecognizer else { return }
      let translation = recognizer.translation(in: recognizer.view)
      if translation.y > UIViewController.pullToDismissThreshold {
        self?.dismiss()
      }
    }
    view.addGestureRecognizer(recognizer)
  }
  
  private static var dismissionCallbackKey: Int = 0
  private var dismissionCallback: (() -> Void)? {
    get { return objc_getAssociatedObject(self, &UIViewController.dismissionCallbackKey) as? () -> Void }
    set { objc_setAssociatedObject(self, &UIViewController.dismissionCallbackKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY) }
  }
  
  public func addPullToDismiss(on scrollView: UIScrollView, dismissionCallback: (() -> Void)? = nil) {
    self.dismissionCallback = dismissionCallback
    scrollView.panGestureRecognizer.addTarget(self, action: #selector(checkDismission(userPanGesture:)))
  }
}
