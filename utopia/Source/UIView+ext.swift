//
//  UIView+ext.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/8/18.
//  Copyright © 2018 Dmitriy Kalachev. All rights reserved.
//

import UIKit

public extension UIView {

  @discardableResult
  public func add(to superview: UIView) -> Self {
    superview.addSubview(self)
    return self
  }

}
