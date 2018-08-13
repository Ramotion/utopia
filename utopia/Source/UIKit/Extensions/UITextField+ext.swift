import UIKit

@IBDesignable
extension UITextField {
  
  @IBInspectable var leftPaddingWidth: CGFloat {
    get {
      return leftView?.frame.size.width ?? 0
    }
    set {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
      leftView = paddingView
      leftViewMode = .always
    }
  }
  
  @IBInspectable var rigthPaddingWidth: CGFloat {
    get {
      return rightView?.frame.size.width ?? 0
    }
    set {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
      rightView = paddingView
      rightViewMode = .always
    }
  }
}
