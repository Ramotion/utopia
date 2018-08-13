//
//  UINavigationController+ext.swift
//  utopia
//
//  Created by Dmitriy Kalachev on 4/19/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import UIKit

public extension UINavigationController {

  func pushViewController(_ vc: UIViewController) {
    pushViewController(vc, animated: true)
  }

  func replace(_ vc: UIViewController, with replacementVC: UIViewController, animated: Bool = true) {
    guard let index = self.viewControllers.index(of: vc)
      else { return }

    var viewControllers = self.viewControllers
    viewControllers[index] = replacementVC
    setViewControllers(viewControllers, animated: animated)
  }

}
