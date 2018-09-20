import Foundation
import UIKit

public enum Haptic {
  case impact(UIImpactFeedbackGenerator.FeedbackStyle)
  case notification(UINotificationFeedbackGenerator.FeedbackType)
  case selection
  
  public func generate() {
    guard #available(iOS 10, *) else { return }
    
    switch self {
    case .impact(let style):
      let generator = UIImpactFeedbackGenerator(style: style)
      generator.prepare()
      generator.impactOccurred()
    case .notification(let type):
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      generator.notificationOccurred(type)
    case .selection:
      let generator = UISelectionFeedbackGenerator()
      generator.prepare()
      generator.selectionChanged()
    }
  }
}
