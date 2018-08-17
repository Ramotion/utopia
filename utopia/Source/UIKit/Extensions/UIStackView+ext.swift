//
//  UIStackView+ext.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/8/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import UIKit

public extension UIStackView {

  static func vertical(_ arrangedSubviews: UIView...) -> UIStackView {
    return vertical(arrangedSubviews)
  }

  static func vertical(_ arrangedSubviews: [UIView]) -> UIStackView {
    return UIStackView(arrangedSubviews: arrangedSubviews).then {
      $0.axis = .vertical
    }
  }

  func clearArrangedSubviews() {
    arrangedSubviews.forEach {
      removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }

  func addArrangedSubviews(_ subviews: [UIView]) {
    subviews.forEach {
      addArrangedSubview($0)
    }
  }

}
