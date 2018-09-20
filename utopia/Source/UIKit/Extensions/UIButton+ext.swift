import Foundation
import UIKit


extension UIButton {
  /**
   Sets the background color to use for the specified button state.
   
   - parameter color: The background color to use for the specified state.
   - parameter state: The state that uses the specified image.
   */
  public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
    setBackgroundImage(UIImage(color: color), for: state)
  }
}
