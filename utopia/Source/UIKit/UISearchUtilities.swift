import UIKit

extension UIViewController {
  
  public func findUp<T>() -> T? where T: UIViewController {
    return findUpVC(self)
  }
  
  public func findDown<T>() -> T? where T: UIViewController {
    return findDownVC(self)
  }
}

func findUpVC<T>(_ base: UIViewController) -> T? where T: UIViewController {
  
  var vc: UIViewController? = base
  
  while vc != nil {
    if let vc = vc?.parent as? T {
      return vc
    } else {
      vc = vc?.parent
    }
  }
  return nil
}

func findDownVC<T>(_ base: UIViewController) -> T? where T: UIViewController {
  var result: T?
  for c in base.childViewControllers {
    if let r = c as? T {
      result = r
    } else {
      result = findDownVC(c)
    }
    if result != nil {
      break
    }
  }
  return result
}

func findDownVC<T>() -> T? where T: UIViewController {
  guard let base = UIApplication.shared.keyWindow?.rootViewController else { return nil }
  if let result = base as? T {
    return result
  }
  return findDownVC(base)
}

extension UIView {
  
  public func first(where condition: @escaping (UIView) -> Bool) -> UIView? {
    return Utopia.first(inView: self, where: condition)
  }
  
  public func find<T>() -> T? where T: UIView {
    return Utopia.findView(self)
  }
  
  public func findSuperView<T>() -> T? where T: UIView {
    return Utopia.findSuperView(self)
  }
  
  public func findAll<T>() -> [T] where T: UIView {
    return findAllViews(self)
  }
}

func first(inView view: UIView, where condition: @escaping (UIView) -> Bool) -> UIView? {
  guard !condition(view) else { return view }
  
  var result: UIView?
  for v in view.subviews {
    if condition(v) {
      result = v
    } else {
      result = first(inView: v, where: condition)
    }
    if result != nil {
      break
    }
  }
  return result
}

func findView<T>(_ root: UIView) -> T? where T: UIView {
  var result: T?
  for v in root.subviews {
    if let r = v as? T {
      result = r
    } else {
      result = findView(v)
    }
    if result != nil {
      break
    }
  }
  return result
}

func findSuperView<T>(_ base: UIView) -> T? where T: UIView {
  var v: UIView? = base
  while v != nil {
    if let v = v?.superview as? T {
      return v
    } else {
      v = v?.superview
    }
  }
  return nil
}

func findAllViews<T>(_ root: UIView) -> [T] where T: UIView {
  var result: [T] = []
  for v in root.subviews {
    if let r = v as? T {
      result.append(r)
    }
    let rv: [T] = findAllViews(v)
    result.append(contentsOf: rv)
  }
  return result
}

extension UIView {
  
  public func findConstraints(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
    let result = constraints.filter { $0.firstAttribute == attribute && $0.firstItem as? NSObject == self }
    return result
  }
  
  public func findSuperviewConstraints(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
    let result = superview?.constraints.filter {
      ($0.firstAttribute == attribute && $0.firstItem as? NSObject == self) ||
      ($0.secondAttribute == attribute && $0.secondItem as? NSObject == self)
    }
    return result ?? []
  }
  
  public var allConstraints: [NSLayoutConstraint] {
    let selfconstraints = constraints.filter { $0.firstItem === self || $0.secondItem === self }
    let superviewConstraints = superview?.constraints.filter { $0.firstItem === self || $0.secondItem === self } ?? []
    return (selfconstraints + superviewConstraints)
  }
}

extension UIView {
  @nonobjc @discardableResult
  
  public func insert(toSuperview superview: UIView, at: Int) -> Self {
    superview.insertSubview(self, at: at)
    return self
  }
}