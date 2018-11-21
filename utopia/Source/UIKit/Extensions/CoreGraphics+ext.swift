import UIKit

public extension CGSize {

  public init(_ value: CGFloat) {
    self.init(width: value, height: value)
  }

  public var asRect: CGRect {
    return CGRect(size: self)
  }
    
  public init(_ width: CGFloat, _ height: CGFloat) {
    self.init(width: width, height: height)
  }

  public func centered(in rect: CGRect) -> CGRect {
    var result = self.asRect
    result.origin.x = (rect.width - width) / 2
    result.origin.y = (rect.height - height) / 2
    return result
  }

  public func centered(in size: CGSize) -> CGRect {
    return centered(in: CGRect(origin: .zero, size: size))
  }
    
  public var asPixelsForMainScreen: CGSize {
    return self * UIScreen.main.scale
  }

  public var center: CGPoint {
    return CGPoint(x: width / 2, y: height / 2)
  }
    
  public static var greatestFiniteMagnitude: CGSize {
    return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
  }
    
  public var area: CGFloat {
    return width * height
  }
}

public extension UIEdgeInsets {
  public init(value: CGFloat) {
    self.init(top: value, left: value, bottom: value, right: value)
  }
}

public extension CGPoint {

  init(_ x: CGFloat, _ y: CGFloat) {
    self.init(x: x, y: y)
  }

}

public extension CGRect {

  public init(size: CGSize) {
    self.init(origin: .zero, size: size)
  }

  public var center: CGPoint {
    return CGPoint(x: midX, y: midY)
  }

  public func insetBy(insets: UIEdgeInsets) -> CGRect {
    let x = origin.x + insets.left
    let y = origin.y + insets.top
    let w = size.width - insets.left - insets.right
    let h = size.height - insets.top - insets.bottom
    return CGRect(x: x, y: y, width: w, height: h)
  }
}

public extension CGAffineTransform {

  public init(scale: CGFloat) {
    self.init(scaleX: scale, y: scale)
  }
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func += (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs + rhs
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func -= (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs - rhs
}

public func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
}

public func *= (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs * rhs
}

public func / (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
}

public func /= (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs / rhs
}

public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
  return CGSize(lhs.width * rhs, lhs.height * rhs)
}
