import Foundation
import UIKit

protocol InteractiveDismiss: class {
    
    var canBeginInteractiveDismiss: Bool { get }
    var backgroundView: UIView { get }
    var contentView: UIView { get }
    
    func setupInteractiveDismission()
    func viewDidCompleteInteractiveDismiss()
    func viewPossiblyWillDissmiss()
}

private struct AssociatedKeys {
    static var exceededThreshold: Int = 0
    static var totalTranslation: Int = 1
    static var gestureDelegate: Int = 2
}

extension InteractiveDismiss where Self: UIViewController {
    
    private var exceededDismissionThreshold: Bool {
        get { return getAssociatedObject(&AssociatedKeys.exceededThreshold) ?? false }
        set { setAssociatedObject(&AssociatedKeys.exceededThreshold, newValue) }
    }
    
    private var totalTranslationY: CGFloat  {
        get { return getAssociatedObject(&AssociatedKeys.totalTranslation) ?? 0 }
        set { setAssociatedObject(&AssociatedKeys.totalTranslation, newValue) }
    }
    
    private var gestureDelegate: GestureRecognizerDelegate? {
        get { return getAssociatedObject(&AssociatedKeys.gestureDelegate) }
        set { setAssociatedObject(&AssociatedKeys.gestureDelegate, newValue) }
    }
    
    func dismissAnimated() {
        animateExit()
    }
    
    func setupInteractiveDismission() {
        
        let panGesture = UIPanGestureRecognizer {[weak self] recognizer in
            self?.didPanView(panGesture: recognizer as! UIPanGestureRecognizer)
        }
        panGesture.cancelsTouchesInView = false
        let delegate = GestureRecognizerDelegate()
        delegate.recognizerShouldBegin = { [unowned self] _ in return self.canBeginInteractiveDismiss }
        panGesture.delegate = delegate
        gestureDelegate = delegate
        view.addGestureRecognizer(panGesture)
    }
    
    private func didPanView(panGesture: UIPanGestureRecognizer) {
        
        // Update translation
        let translation = panGesture.translation(in: view)
        
        // Check which view should update
        if contentView.frame.origin.y + translation.y > 0 {
            
            // We are scrolling down
            totalTranslationY += translation.y
            
            // Check threshold
            if totalTranslationY > Theme.scrollDownSlopThreshold {
                contentView.frame.origin.y += translation.y
                
                // Updated the view behind this with the proper index
                // Prevents a jitter when exiting
                if !exceededDismissionThreshold {
                    exceededDismissionThreshold = true
                    viewPossiblyWillDissmiss()
                }
            } else {
                contentView.frame.origin.y = 0
            }
            
            // Perform changes
            performTranslationBasedStyles()
        }
        
        // Handle extras
        switch panGesture.state {
        case .ended:
            if totalTranslationY > Theme.scrollDownSlopThreshold {
                
                // Determine velocity
                let velocity = panGesture.velocity(in: view)
                let projectedY = Inertia.project(initialVelocity: velocity.y)
                let duration = TimeInterval(view.frame.size.height / velocity.y)
                
                // Handle case
                if projectedY >= Theme.flingToDismissVelocityThreshold {
                    animateExit(duration, projectedY)
                } else if contentView.frame.origin.y >= view.frame.height * 0.4 {
                    animateExit()
                } else {
                    let springVelocity = projectedY / view.frame.height
                    animateBack(intensity: springVelocity)
                }
            }
            
            // Reset
            totalTranslationY = 0
            exceededDismissionThreshold = false
        default: break
        }
        
        // Reset
        panGesture.setTranslation(.zero, in: view)
    }
    
    private func animateExit(_ duration: TimeInterval = 0.33, _ projectedY: CGFloat = 0) {
        UIView.animate(withDuration: duration, animations: {
            self.contentView.frame.origin.y = self.view.frame.height + projectedY
            self.backgroundView.alpha = 0
        }) { _ in
            self.viewDidCompleteInteractiveDismiss()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func animateBack(intensity: CGFloat) {
        let velocity = intensity.limited(1, 1 + intensity)
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: .allowUserInteraction, animations: {
            self.contentView.frame.origin.y = 0
            self.backgroundView.alpha = 1
        }, completion: nil)
    }
    
    // Changes styles based on the drag og the content view
    private func performTranslationBasedStyles() {
        let translation = 1 - (contentView.frame.origin.y / view.frame.height)
        backgroundView.alpha = translation
    }
}


// MARK: - Theme
private enum Theme {
    static let scrollDownSlopThreshold: CGFloat = 36
    static let flingToDismissVelocityThreshold: CGFloat = 150
}
