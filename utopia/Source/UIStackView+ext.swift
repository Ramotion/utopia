//
//  UIStackView+ext.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/8/18.
//  Copyright © 2018 Dmitriy Kalachev. All rights reserved.
//

import UIKit

public extension UIStackView {

  public func clearArrangedSubviews() {
    arrangedSubviews.forEach {
      removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }

  public func addArrangedSubviews(_ subviews: [UIView]) {
    subviews.forEach {
      addArrangedSubview($0)
    }
  }

}
