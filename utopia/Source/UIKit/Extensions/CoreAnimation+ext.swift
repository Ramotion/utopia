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

extension CALayer {
  
  @discardableResult
  public func add(toSuperlayer layer: CALayer) -> Self {
    layer.addSublayer(self)
    return self
  }
  
  public func removeAnimation(forLayerKey key: CALayerAnimatableProperty) {
    removeAnimation(forKey: key.rawValue)
  }
}

public enum CALayerAnimatableProperty: String {
  case opacity
  case shadowOpacity
  case position = "position"
  case positionX = "position.x"
  case positionY = "position.y"
  case bounds
  case backgroundColor
  case rotation = "transform.rotation"
  case scale = "transform.scale"
  case translationX = "transform.translation.x"
  case borderWidth
  case borderColor
  case cornerRadius = "cornerRadius"
  case shadowPath
}

extension CAPropertyAnimation {
  
  public convenience init(property: CALayerAnimatableProperty) {
    self.init(keyPath: property.rawValue)
  }
}

extension CABasicAnimation {
  
  public enum AnimationType {
    case fadeIn
    case fadeOut
    case opacity(from: Float, to: Float)
    case shadowOpacity(from: Float, to: Float)
    case drop(from: CGFloat, to: CGFloat)
    case bounds(from: CGRect, to: CGRect)
    case backgroundColor(from: CGColor, to: CGColor)
    case borderWidth(from: CGFloat, to: CGFloat)
    case borderColor(from: CGColor, to: CGColor)
    case scale(from: CGFloat, to: CGFloat)
    case rotate(from: CGFloat, to: CGFloat)
    case cornerRadius(from: CGFloat, to: CGFloat)
    case slide(to: CGFloat)
    case position(from: CGPoint, to: CGPoint)
    case shadowPath(from: CGPath, to: CGPath)
  }
  
  public class func ofType(_ type: AnimationType) -> CABasicAnimation {
    switch type {
    case .fadeIn:
      return ofType(.opacity(from: 0, to: 1))
      
    case .fadeOut:
      return ofType(.opacity(from: 1, to: 0))
      
    case let .opacity(from, to):
      let anim = CABasicAnimation(property: .opacity)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .shadowOpacity(from, to):
      let anim = CABasicAnimation(property: .shadowOpacity)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .drop(from, to):
      let anim = CABasicAnimation(property: .positionY)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .bounds(from, to):
      let anim = CABasicAnimation(property: .bounds)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .backgroundColor(from, to):
      let anim = CABasicAnimation(property: .backgroundColor)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .borderColor(from, to):
      let anim = CABasicAnimation(property: .borderColor)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .borderWidth(from, to):
      let anim = CABasicAnimation(property: .borderWidth)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .scale(from, to):
      let anim = CABasicAnimation(property: .scale)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .rotate(from, to):
      let anim = CABasicAnimation(property: .rotation)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .cornerRadius(from, to):
      let anim = CABasicAnimation(property: .cornerRadius)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .slide(toValue):
      let anim = CABasicAnimation(property: .positionX)
      anim.toValue = toValue
      
      return anim
      
    case let .position(from, to):
      let anim = CABasicAnimation(property: .position)
      anim.fromValue = from
      anim.toValue = to
      return anim
      
    case let .shadowPath(from, to):
      let anim = CABasicAnimation(property: .shadowPath)
      anim.fromValue = from
      anim.toValue = to
      return anim
    }
  }
}

extension CAAnimationGroup {
  
  public convenience init(_ animations: [CAAnimation]) {
    self.init()
    self.animations = animations
  }
  
  public convenience init(basic animations: [CABasicAnimation.AnimationType]) {
    self.init()
    self.animations = animations.map { CABasicAnimation.ofType($0) }
  }
}

extension CAAnimation {
  public func add(to layer: CALayer, forLayerKey key: CALayerAnimatableProperty) {
    layer.add(self, forKey: key.rawValue)
  }
  
  public func add(to layer: CALayer, forKey key: String) {
    layer.add(self, forKey: key)
  }
}

extension CAMediaTiming {
  
  public func setBeginTime(for layer: CALayer, delay: CFTimeInterval) {
    beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) + delay
  }
}

extension CATransition {
  
  public enum Kind {
    case fade, moveIn, push, reveal
    var value: String {
      switch self {
      case .fade:     return convertFromCATransitionType(CATransitionType.fade)
      case .moveIn:   return convertFromCATransitionType(CATransitionType.moveIn)
      case .push:     return convertFromCATransitionType(CATransitionType.push)
      case .reveal:   return convertFromCATransitionType(CATransitionType.reveal)
      }
    }
  }
  
  public enum Subkind {
    case fromRight, fromLeft, fromTop, fromBottom
    var value: String {
      switch self {
      case .fromRight:    return convertFromCATransitionSubtype(CATransitionSubtype.fromRight)
      case .fromLeft:     return convertFromCATransitionSubtype(CATransitionSubtype.fromLeft)
      case .fromTop:      return convertFromCATransitionSubtype(CATransitionSubtype.fromTop)
      case .fromBottom:   return convertFromCATransitionSubtype(CATransitionSubtype.fromBottom)
      }
    }
  }
  
  public convenience init(type: Kind, subtype: Subkind? = nil) {
    self.init()
    self.type = convertToCATransitionType(type.value)
    if let subtype = subtype {
      self.subtype = convertToOptionalCATransitionSubtype(subtype.value)
    }
  }
  
  public func add(toLayer layer: CALayer) {
    layer.add(self, forKey: kCATransition)
  }
  
  public func add(toView view: UIView) {
    view.layer.add(self, forKey: kCATransition)
  }
  
}

extension CATransaction {
  public static func noActions(_ block: () -> Void) {
    begin()
    setDisableActions(true)
    block()
    commit()
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalCATransitionSubtype(_ input: String?) -> CATransitionSubtype? {
	guard let input = input else { return nil }
	return CATransitionSubtype(rawValue: input)
}
