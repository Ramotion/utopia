import UIKit

public extension UIView {
  
  @discardableResult
  public func add(to superview: UIView) -> Self {
    superview.addSubview(self)
    return self
  }
  
  @discardableResult
  public func insert(to superview: UIView, at index: Int) -> Self {
    superview.insertSubview(self, at: index)
    return self
  }
  
  @discardableResult
  public func insert(to superview: UIView, above view: UIView) -> Self {
    superview.insertSubview(self, aboveSubview: view)
    return self
  }
  
  @discardableResult
  public func insert(to superview: UIView, below view: UIView) -> Self {
    superview.insertSubview(self, belowSubview: view)
    return self
  }
  
  @discardableResult
  public func add(to stackview: UIStackView) -> Self {
    stackview.addArrangedSubview(self)
    return self
  }
  
  convenience init(size: CGSize) {
    self.init(frame: CGRect(origin: CGPoint.zero, size: size))
  }
}


extension UIView {
  
  public func removeAllConstraintsDownInHierarchy () {
    self.removeSelfConstraints()
    let subviews: [UIView] = findAll()
    subviews.forEach { $0.removeSelfConstraints() }
  }
  
  public func removeSelfConstraints () {
    var superview = self.superview
    while superview != nil {
      for c in superview!.constraints {
        if c.firstItem as! NSObject == self || c.secondItem as! NSObject == self {
          superview?.removeConstraint(c)
        }
      }
      superview = superview?.superview
    }
    self.removeConstraints(self.constraints)
    self.translatesAutoresizingMaskIntoConstraints = true
  }
}

extension UIView {
  
  public func pauseLayerAnimations() {
    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
    layer.speed = 0.0
    layer.timeOffset = pausedTime
  }
  
  public func resumeLayerAnimations() {
    let pausedTime = layer.timeOffset
    layer.speed = 1.0
    layer.timeOffset = 0.0
    layer.beginTime = 0.0
    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    layer.beginTime = timeSincePause
  }
}
