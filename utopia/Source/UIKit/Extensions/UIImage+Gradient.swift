import UIKit
import CoreImage

extension UIImage {
  
  public enum Direction {
    case right
    case left
    case up
    case down
  }
  
  public static func gradientImage(startColor: UIColor,
                                   endColor: UIColor,
                                   size: CGSize,
                                   direction: Direction) -> UIImage {
    
    return UIImage.gradientImage(colors: [startColor, endColor],
                                 locations: [0,1],
                                 size: size,
                                 direction: direction)
  }
  
  
  public static func gradientImage(colors: [UIColor],
                                   locations: [CGFloat],
                                   size: CGSize,
                                   direction: Direction) -> UIImage {
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    switch direction {
    case .left:
      startPoint = CGPoint()
      endPoint = CGPoint(x: 1.0, y: 0.0)
    case .right:
      startPoint = CGPoint(x: 1.0, y: 0.0)
      endPoint = CGPoint()
    case .up:
      startPoint = CGPoint(x: 0.0, y: 1.0)
      endPoint = CGPoint()
    case .down:
      startPoint = CGPoint()
      endPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    return UIImage.gradientImage(colors: colors,
                                 locations: locations,
                                 startPoint: startPoint,
                                 endPoint: endPoint, size: size)
  }
  
  
  public static func gradientImage(colors: [UIColor], locations: [CGFloat], startPoint: CGPoint, endPoint: CGPoint, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContext(size)
    defer { UIGraphicsEndImageContext() }
    
    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
    UIGraphicsPushContext(context)
    
    let components = colors.reduce([]) { (currentResult: [CGFloat], currentColor: UIColor) -> [CGFloat] in
      var result = currentResult
      
      guard let components = currentColor.cgColor.components else { return result }
      if currentColor.cgColor.numberOfComponents == 2 {
        result.append(contentsOf: [components[0], components[0], components[0], components[1]])
      } else {
        result.append(contentsOf:[components[0], components[1], components[2], components[3]])
      }
      
      return result
    }
    
    guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: components, locations: locations, count: colors.count) else { return UIImage() }
    
    let transformedStartPoint = CGPoint(x: startPoint.x * size.width, y: startPoint.y * size.height)
    let transformedEndPoint = CGPoint(x: endPoint.x * size.width, y: endPoint.y * size.height)
    context.drawLinearGradient(gradient, start: transformedStartPoint, end: transformedEndPoint, options: [])
    UIGraphicsPopContext()
    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    
    return gradientImage ?? UIImage()
  }
}
