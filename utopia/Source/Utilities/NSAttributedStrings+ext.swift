import Foundation
import UIKit

extension NSMutableAttributedString {
  
  public func addAttributes(for string: String, attributes: [NSAttributedString.Key : Any]) -> Self {
    let range = (self.string as NSString).range(of: string)
    addAttributes(attributes, range: range)
    return self
  }
  
  public func setAsLink(textToFind:String, linkURL:String, color: UIColor, font: UIFont? = nil) -> Self {
    let foundRange = self.mutableString.range(of: textToFind)
    if foundRange.location != NSNotFound {
      self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
      self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: foundRange)
      if let font = font { self.addAttribute(NSAttributedString.Key.font, value: font, range: foundRange) }
    }
    return self
  }
}

extension NSAttributedString {
  
  public func size(constrainedToWidth width: CGFloat? = nil) -> CGSize {

    let size: CGSize = CGSize(width: width ?? CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    let result = boundingRect(with: size, options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil).size
    return result
  }
}
