import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass


protocol TouchInteraction: class {
    func setupDefaultTouchInteraction()
}


extension UIView: TouchInteraction {}


extension TouchInteraction where Self: UIView {
    
    func setupDefaultTouchInteraction() {
        
        let recognizer = TouchInteractionRecognizer { recognizer in
            switch recognizer.state {
            case .began:
                UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.alpha = 0.6
                })
            case .ended, .failed, .cancelled:
                UIView.animate(withDuration: 0.175, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.alpha = 1
                })
            default: break
            }
        }
        
        self.addGestureRecognizer(recognizer)
        self.isUserInteractionEnabled = true
    }
}


class TouchInteractionRecognizer: UIGestureRecognizer {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        delaysTouchesBegan = false
        delaysTouchesEnded = false
        cancelsTouchesInView = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if touches.count != 1 {
            state = .failed
        }
        state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if touches.count != 1 {
            state = .failed
        }
        state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = .cancelled
    }
    
    override func reset() {
        super.reset()
        state = .possible
    }
}
