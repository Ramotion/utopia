//
//  CoreAnimation+ext.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/8/18.
//  Copyright © 2018 Dmitriy Kalachev. All rights reserved.
//

import UIKit

public extension CALayer {

  @discardableResult
  public func add(to superlayer: CALayer) -> Self {
    superlayer.addSublayer(self)
    return self
  }

}

public extension CATransaction {
  
  public static func withoutActions(_ block: () -> Void) {
    begin()
    setDisableActions(true)
    block()
    commit()
  }

}
