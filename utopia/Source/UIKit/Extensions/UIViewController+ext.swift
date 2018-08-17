import UIKit

extension UIViewController {

    /// Retrieve the view controller currently on-screen
    ///
    /// Based off code here: http://stackoverflow.com/questions/24825123/get-the-current-view-controller-from-the-app-delegate
    public static var current: UIViewController? {
        if let controller = UIApplication.shared.keyWindow?.rootViewController {
            return findCurrent(controller)
        }
        return nil
    }

    private static func findCurrent(_ controller: UIViewController) -> UIViewController {
        if let controller = controller.presentedViewController {
            return findCurrent(controller)
        } else if let controller = controller as? UISplitViewController, let lastViewController = controller.viewControllers.first, controller.viewControllers.count > 0 {
            return findCurrent(lastViewController)
        } else if let controller = controller as? UINavigationController, let topViewController = controller.topViewController, controller.viewControllers.count > 0 {
            return findCurrent(topViewController)
        } else if let controller = controller as? UITabBarController, let selectedViewController = controller.selectedViewController, (controller.viewControllers?.count ?? 0) > 0 {
            return findCurrent(selectedViewController)
        } else {
            return controller
        }
    }
}

extension UIViewController {
  
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
  
  public func dismissToRootViewController(animated: Bool) {
    var vc = self
    while let current = vc.presentingViewController {
      vc = current
    }
    vc.dismiss(animated: animated, completion: nil)
    vc.navigationController?.popToRootViewController(animated: animated)
  }
}

extension UIViewController {
  public func add(_ child: UIViewController) {
    addChildViewController(child)
    view.addSubview(child.view)
    child.didMove(toParentViewController: self)
  }
  
  public func remove() {
    guard parent != nil else {
      return
    }
    
    willMove(toParentViewController: nil)
    removeFromParentViewController()
    view.removeFromSuperview()
  }
}
