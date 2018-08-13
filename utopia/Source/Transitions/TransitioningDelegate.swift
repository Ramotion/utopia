import Foundation
import UIKit

public final class TransitioningDelegate<T,R>: NSObject, UIViewControllerTransitioningDelegate where T: UIViewControllerAnimatedTransitioning, R: UIViewControllerAnimatedTransitioning {
    
    public let presentation: T
    public let dismiss: R
    
    public init(present: T, dismiss: R) {
        self.presentation = present
        self.dismiss = dismiss
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentation
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismiss
    }
}
