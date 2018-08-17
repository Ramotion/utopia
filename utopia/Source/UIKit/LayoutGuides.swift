import Foundation
import UIKit


extension UIView {
  
  public var safeLayoutGuide: UILayoutGuide {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide
    } else {
      return layoutMarginsGuide
    }
  }
  
  public var safeTopAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.topAnchor
    } else {
      return topAnchor
    }
  }
  
  public var safeBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.bottomAnchor
    } else {
      return bottomAnchor
    }
  }
  
  public var safeRightAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.rightAnchor
    } else {
      return rightAnchor
    }
  }
  
  public var safeLeftAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.leftAnchor
    } else {
      return leftAnchor
    }
  }
  
  public var safeLeadingAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.leadingAnchor
    } else {
      return leadingAnchor
    }
  }
  
  public var safeTrailingAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.trailingAnchor
    } else {
      return trailingAnchor
    }
  }
  
  public var safeCenterXAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.centerXAnchor
    } else {
      return centerXAnchor
    }
  }
  
  public var safeCenterYAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.centerYAnchor
    } else {
      return centerYAnchor
    }
  }
  
  public var safeHeightAnchor: NSLayoutDimension {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.heightAnchor
    } else {
      return heightAnchor
    }
  }
  
  public var safeWidthAnchor: NSLayoutDimension {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.widthAnchor
    } else {
      return widthAnchor
    }
  }
}
