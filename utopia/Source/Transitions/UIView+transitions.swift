import Foundation
import UIKit

extension UIView {
  
  public typealias AnimationBlock = (TimeInterval, TimeInterval) -> Void //duration, delay
  
  private static var customTransitionIdKey: Int = 12
  private static var appearanceAnimationKey: Int = 12
  private static var disappearanceAnimationKey: Int = 12
  
  public var customTransitionId: String? {
    get {
      return objc_getAssociatedObject(self, &UIView.customTransitionIdKey) as? String
    }
    set {
      objc_setAssociatedObject(self, &UIView.customTransitionIdKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
  }
  
  public var appearanceAnimation: AnimationBlock? {
    get {
      return objc_getAssociatedObject(self, &UIView.appearanceAnimationKey) as? AnimationBlock
    }
    set {
      objc_setAssociatedObject(self, &UIView.appearanceAnimationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  public var disappearanceAnimation: AnimationBlock? {
    get {
      return objc_getAssociatedObject(self, &UIView.disappearanceAnimationKey) as? AnimationBlock
    }
    set {
      objc_setAssociatedObject(self, &UIView.disappearanceAnimationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  public func findView(withTransitionId: String) -> UIView? {
    return self.first(where: { $0.customTransitionId == withTransitionId })
  }
}
