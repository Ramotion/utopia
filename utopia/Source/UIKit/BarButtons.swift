import Foundation
import UIKit


extension UIBarButtonItem {
  
  private class Action {
    var action: () -> Void
    
    init(action: @escaping () -> Void) {
      self.action = action
    }
    
    @objc fileprivate func handleAction(_ sender: UIBarButtonItem) {
      action()
    }
  }
  
  private struct AssociatedKeys {
    static var ActionName = "action"
  }
  
  private var barButtonAction: Action? {
    set { objc_setAssociatedObject(self, &AssociatedKeys.ActionName, newValue, .OBJC_ASSOCIATION_RETAIN) }
    get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionName) as? Action }
  }
  
  public convenience init(image: UIImage?, style: UIBarButtonItemStyle = .plain, action: @escaping () -> Void) {
    let handler = Action(action: action)
    self.init(image: image, style: style, target: handler, action: #selector(Action.handleAction(_:)))
    barButtonAction = handler
  }
  
  public convenience init(title: String?, style: UIBarButtonItemStyle = .plain, action: @escaping () -> Void) {
    let handler = Action(action: action)
    self.init(title: title, style: style, target: handler, action: #selector(Action.handleAction(_:)))
    barButtonAction = handler
  }
  
  public convenience init(barButtonSystemItem: UIBarButtonSystemItem, action: @escaping () -> Void) {
    let handler = Action(action: action)
    self.init(barButtonSystemItem: barButtonSystemItem, target: handler, action: #selector(Action.handleAction(_:)))
    barButtonAction = handler
  }
  
  public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, action: @escaping () -> Void) {
    let handler = Action(action: action)
    self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: handler, action: #selector(Action.handleAction(_:)))
    barButtonAction = handler
  }
}
