import Foundation
import UIKit

public struct DisplaySize {
    public static let iphone4     = CGSize(width: 320, height: 480)
    public static let iphone5     = CGSize(width: 320, height: 568)
    public static let iphone6     = CGSize(width: 375, height: 667)
    public static let iphone6plus = CGSize(width: 414, height: 736)
    public static let iphoneX     = CGSize(width: 375, height: 812)
    public static let iphoneXR    = CGSize(width: 414, height: 896)
    public static let iPad9       = CGSize(width: 768, height: 1024)
    public static let ipad10      = CGSize(width: 834, height: 1112)
    public static let ipad12      = CGSize(width: 1024, height: 1366)
    public static let unknown     = CGSize.zero
}

public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    case iphoneX
    case iphoneXR
    case iphoneXM
    case ipad9
    case ipad10
    case ipad12
}

public enum Display {
    public static var width         : CGFloat { return UIScreen.main.bounds.size.width }
    public static var height        : CGFloat { return UIScreen.main.bounds.size.height }
    public static var maxLength     : CGFloat { return max(width, height) }
    public static var minLength     : CGFloat { return min(width, height) }
    public static var zoomed        : Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    public static var retina        : Bool { return UIScreen.main.scale >= 2.0 }
    public static var phone         : Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    public static var pad           : Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    
    public static var navbarSize : CGFloat {
        return (Display.height == 812 || Display.height == 896) ? 88 : 64
    }
    public static var bottombarSize : CGFloat {
        return (Display.height == 812 || Display.height == 896) ? 34 : 0
    }
    
    public static var displayType: DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        } else if phone && maxLength == 568 {
            return .iphone5
        } else if phone && maxLength == 667 {
            return .iphone6
        } else if phone && maxLength == 736 {
            return .iphone6plus
        } else if phone && maxLength == 896 {
            return .iphoneXR
        } else if phone && maxLength == 812 {
            return .iphoneX
        } else if pad && maxLength == 1024 {
            return .ipad9
        } else if pad && maxLength == 1112 {
            return .ipad10
        } else if pad && maxLength == 1366 {
            return .ipad12
        }
        return .unknown
    }
}
