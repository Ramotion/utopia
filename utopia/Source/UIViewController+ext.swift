//
//  UIViewController+ext.swift
//  utopia_Example
//
//  Created by Alex K on 18/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    // SwifterSwift: Check if ViewController is onscreen and not hidden. from https://github.com/SwifterSwift/SwifterSwift
    public var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return self.isViewLoaded && view.window != nil
    }
    
    public func dismiss() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
}
