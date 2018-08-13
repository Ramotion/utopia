//
//  CoreGraphics+ext.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/8/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import UIKit

public extension CGSize {

  init(_ value: CGFloat) {
    self.init(width: value, height: value)
  }

  init(_ width: CGFloat, _ height: CGFloat) {
    self.init(width: width, height: height)
  }

  var asRect: CGRect {
    return CGRect(size: self)
  }

  func centered(in rect: CGRect) -> CGRect {
    var result = self.asRect
    result.origin.x = (rect.width - width) / 2
    result.origin.y = (rect.height - height) / 2
    return result
  }

  var asPixelsForMainScreen: CGSize {
    return self * UIScreen.main.scale
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

  init(size: CGSize) {
    self.init(origin: .zero, size: size)
  }

  var center: CGPoint {
    return CGPoint(x: midX, y: midY)
  }

}

public extension CGAffineTransform {

  init(scale: CGFloat) {
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
