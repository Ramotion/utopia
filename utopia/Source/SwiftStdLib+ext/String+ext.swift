import Foundation
import UIKit

public extension Optional where Wrapped == String {
  var isNilOrEmpty: Bool {
    switch self {
    case let string?:
      return string.isEmpty
    case nil:
      return true
    }
  }
}


extension String {

  public func size(withFont font: UIFont, constrainedToWidth width: CGFloat? = nil) -> CGSize {
    //TODO: update this method after Swift 4.2 migration
    
    let size: CGSize
    if let width = width {
      size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    } else {
      size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
    
    let attributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: font ]
    let result = (self as NSString).boundingRect(with: size,options: [ .usesLineFragmentOrigin ], attributes: attributes, context: nil).size
    
    return result
  }
}




