import Foundation
import UIKit

extension UIViewController {
  
  private static var statusBarSubstrateKey: Int = 0
  
  public var statusBarSubstrate: UIView? {
    get {
      return objc_getAssociatedObject(self, &UIViewController.statusBarSubstrateKey) as? UIView
    }
    set {
      objc_setAssociatedObject(self, &UIViewController.statusBarSubstrateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
  
  public func setupStatusBarSubstrate(color: UIColor, force: Bool = false) {
    guard Display.displayType == .iphoneX || force else { return }
    
    if let statusBarSubstrate = statusBarSubstrate {
      statusBarSubstrate.backgroundColor = color
      return
    }
    
    let substrate = UIView().add(to: view).then {
      $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      $0.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      $0.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
      $0.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height).isActive = true
      $0.backgroundColor = color
      $0.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    statusBarSubstrate = substrate
  }
}
