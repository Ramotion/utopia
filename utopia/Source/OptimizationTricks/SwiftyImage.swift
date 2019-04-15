import UIKit

public extension UIImage
{
    final var isOpaque: Bool {
        let alphaInfo = cgImage?.alphaInfo
        return !(alphaInfo == .first || alphaInfo == .last || alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast)
    }

    final func reSize(to size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    final func reSize(toFit size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else { return self }
        
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        var resizeFactor: CGFloat
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
    
        return scaledImage
    }
    
    final func reSize(toFill size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else { return self }

        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        var resizeFactor: CGFloat
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.height / self.size.height
        } else {
            resizeFactor = size.width / self.size.width
        }
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    final func rounded(withCornerRadius radius: CGFloat, divideRadiusByImageScale: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let scaledRadius = divideRadiusByImageScale ? radius / scale : radius
        
        let clippingPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: scaledRadius)
        clippingPath.addClip()
        
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    final func roundedIntoCircle() -> UIImage {
        let radius = min(size.width, size.height) / 2.0
        var squareImage = self
        if size.width != size.height {
            let squareDimension = min(size.width, size.height)
            let squareSize = CGSize(width: squareDimension, height: squareDimension)
            squareImage = reSize(toFill: squareSize)
        }
        
        UIGraphicsBeginImageContextWithOptions(squareImage.size, false, 0.0)
        let clippingPath = UIBezierPath( roundedRect: CGRect(origin: CGPoint.zero, size: squareImage.size), cornerRadius: radius)
        clippingPath.addClip()
        squareImage.draw(in: CGRect(origin: CGPoint.zero, size: squareImage.size))
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
}
