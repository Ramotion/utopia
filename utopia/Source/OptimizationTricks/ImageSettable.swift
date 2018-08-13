import UIKit


public extension UIView {
  public var backgroundImage: UIImage? {
    get {
      guard let obj = layer.contents else { return nil }
      return UIImage(cgImage: obj as! CGImage)
    }
    set {
      layer.contents = newValue?.cgImage
      if newValue?.isOpaque == true {
        isOpaque = true
      }
      else {
        updateOpaque()
      }
    }
  }
}


public extension UIView {
  public final func updateOpaque() {
    if let color = backgroundColor, color.alphaValue == 1.0, alpha == 1.0 {
      isOpaque = true
    }
    else {
      isOpaque = false
    }
  }
}
