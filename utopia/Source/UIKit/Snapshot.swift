import Foundation
import UIKit


public extension UIView {
  
  public func snapshotImage(opaque: Bool = true, scale: CGFloat = UIScreen.main.scale * 2, afterScreenUpdates: Bool = false) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
    drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
    let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return snapshotImage
  }
  
  public func snapshotView(opaque: Bool = true, scale: CGFloat = UIScreen.main.scale * 2, afterScreenUpdates: Bool = false) -> UIView? {
    if let snapshotImage = snapshotImage(opaque: opaque, scale: scale, afterScreenUpdates: afterScreenUpdates) {
      return UIImageView(image: snapshotImage)
    } else {
      return nil
    }
  }
  
  public func snapshotLayer(opaque: Bool = true, scale: CGFloat = UIScreen.main.scale * 2) -> UIImage? {
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}
