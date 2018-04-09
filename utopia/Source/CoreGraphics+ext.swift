//
//  CoreGraphics+ext.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/8/18.
//  Copyright © 2018 Dmitriy Kalachev. All rights reserved.
//

import UIKit

public extension CGSize {

  public init(_ value: CGFloat) {
    self.init(width: value, height: value)
  }

  public var asRect: CGRect {
    return CGRect(size: self)
  }

  public func centered(in rect: CGRect) -> CGRect {
    var result = self.asRect
    result.origin.x = (rect.width - width) / 2
    result.origin.y = (rect.height - height) / 2
    return result
  }

}

public extension CGRect {

  public init(size: CGSize) {
    self.init(origin: .zero, size: size)
  }

  public var center: CGPoint {
    return CGPoint(x: midX, y: midY)
  }

}
