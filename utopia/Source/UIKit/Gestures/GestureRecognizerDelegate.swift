import Foundation
import UIKit

class GestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    var recognizerShouldBegin: ((UIGestureRecognizer) -> Bool)? = nil
    var shouldRecognizeSimultaneously: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)? = nil
    var shouldRequireFailureOf: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)? = nil
    var shouldRequireFailureBy: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)? = nil
    var shouldReceiveTouch: ((UIGestureRecognizer, UITouch) -> Bool)? = nil
    var shouldReceivePress: ((UIGestureRecognizer, UIPress) -> Bool)? = nil
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return recognizerShouldBegin?(gestureRecognizer) ?? true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer) ?? true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldRequireFailureOf?(gestureRecognizer, otherGestureRecognizer) ?? true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldRequireFailureBy?(gestureRecognizer, otherGestureRecognizer) ?? false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return shouldReceiveTouch?(gestureRecognizer, touch) ?? true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return shouldReceivePress?(gestureRecognizer, press) ?? true
    }
}
