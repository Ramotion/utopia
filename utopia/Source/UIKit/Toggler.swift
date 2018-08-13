import Foundation
import UIKit

public protocol Togglable: class {
  func selectedToggle(select: Bool)
}

extension UIControl: Togglable {
  @objc public func selectedToggle(select: Bool) {
    isSelected = select
  }
}

extension UISwitch {
  public override func selectedToggle(select: Bool) {
    setOn(select, animated: true)
  }
}

public struct Toggler {
  var togglers = [Togglable]()
  
  public init(default index: Int = 0, togglers: [Togglable]) {
    self.togglers = togglers
    toggleControl(toggle: togglers[index], togglers: togglers)
  }
  
  public func on(toggle: Togglable) {
    toggleControl(toggle: toggle, togglers: togglers)
  }
  
  public func onAt(index: Int) {
    toggleControl(toggle: togglers[index], togglers: togglers)
  }
  
  public mutating func add(toggle: Togglable) {
    togglers.append(toggle)
  }
  
  public mutating func remove(at index: Int) {
    guard index < togglers.count else {
      fatalError("Index is out of array")
    }
    togglers.remove(at: index)
  }
  
  private func toggleControl(toggle: Togglable, togglers: [Togglable]) {
    togglers.enumerated().forEach {
      toggleStatus(toggle: $0.element, on: $0.element === toggle)
    }
  }
  
  private func toggleStatus(toggle: Togglable, on: Bool) {
    toggle.selectedToggle(select: on)
  }
}

public class ButtonsTogglerView: UIStackView {
  public var onToggle: ((Int) -> Void)? = nil
  private let toggler: Toggler
  public private(set) var currentIndex: Int
  
  public required init(defaultIndex index: Int = 0,
                       buttons: [UIButton],
                       axis: UILayoutConstraintAxis = .horizontal,
                       spacing: CGFloat = 30,
                       distribution: UIStackViewDistribution = .equalSpacing,
                       alignment: UIStackViewAlignment = .fill) {
    
    currentIndex = index
    toggler = Toggler(default: index, togglers: buttons)
    super.init(frame: CGRect.zero)
    addArrangedSubviews(buttons)

    self.axis = axis
    self.alignment = alignment
    self.distribution = distribution
    self.spacing = spacing
    
    for (index, button) in buttons.enumerated() {
      button.onTouchUpInside.subscribe(with: self, callback: {[unowned self] _ in
        guard index != self.currentIndex else { return }
        
        self.currentIndex = index
        self.toggler.onAt(index: index)
        self.onToggle?(index)
      })
    }
  }
  
  public required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public class ButtonsToggler {
  public var onToggle: ((Int) -> Void)? = nil
  private let toggler: Toggler
  public private(set) var currentIndex: Int
  
  public func selectIndex(at index: Int) {
    guard index >= 0 && index < toggler.togglers.count else { return }
    toggler.onAt(index: index)
    currentIndex = index
  }
  
  public init(defaultIndex index: Int = 0, buttons: [UIButton]) {
    currentIndex = index
    toggler = Toggler(default: index, togglers: buttons)
    
    for (index, button) in buttons.enumerated() {
      button.onTouchUpInside.subscribe(with: self, callback: {[unowned self] _ in
        guard index != self.currentIndex else { return }
        
        self.currentIndex = index
        self.toggler.onAt(index: index)
        self.onToggle?(index)
      })
    }
  }
}
