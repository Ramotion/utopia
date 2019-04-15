import UIKit

public extension UIButton {
  /// Enum to determine the title position with respect to the button image
  ///
  /// - top: title above button image
  /// - bottom: title below button image
  /// - left: title to the left of button image
  /// - right: title to the right of button image
  enum Position: Int {
    case top, bottom, left, right
  }
  
  /// This method sets an image and title for a UIButton and
  ///   repositions the titlePosition with respect to the button image.
  ///
  /// - Parameters:
  ///   - image: Button image
  ///   - title: Button title
  ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
  ///   - additionalSpacing: Spacing between image and title
  ///   - state: State to apply this behaviour
  func set(image: UIImage?, title: String, titlePosition: Position, spacing: CGFloat, state: UIControl.State){
    imageView?.contentMode = .center
    setImage(image, for: state)
    setTitle(title, for: state)
    titleLabel?.contentMode = .center
    
    adjust(title: title as NSString, at: titlePosition, spacing: spacing)
    
  }
  
  /// This method sets an image and an attributed title for a UIButton and
  ///   repositions the titlePosition with respect to the button image.
  ///
  /// - Parameters:
  ///   - image: Button image
  ///   - title: Button attributed title
  ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
  ///   - additionalSpacing: Spacing between image and title
  ///   - state: State to apply this behaviour
  func set(image: UIImage?, attributedTitle title: NSAttributedString, titlePosition: Position, spacing: CGFloat, state: UIControl.State){
    imageView?.contentMode = .center
    setImage(image, for: state)
    
    adjust(attributedTitle: title, at: titlePosition, spacing: spacing)
    
    titleLabel?.contentMode = .center
    setAttributedTitle(title, for: state)
  }
  
  
  // MARK: Private Methods
  
  private func adjust(title: NSString, at position: Position, spacing: CGFloat) {
    let imageRect: CGRect = self.imageRect(forContentRect: frame)
    
    // Use predefined font, otherwise use the default
    let titleFont: UIFont = titleLabel?.font ?? UIFont()
    let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
    
    arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, spacing: spacing)
  }
  
  private func adjust(attributedTitle: NSAttributedString, at position: Position, spacing: CGFloat) {
    let imageRect: CGRect = self.imageRect(forContentRect: frame)
    let titleSize = attributedTitle.size()
    
    arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, spacing: spacing)
  }
  
  private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: Position, spacing: CGFloat) {
    switch (position) {
    case .top:
      titleEdgeInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
      imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
      contentEdgeInsets = UIEdgeInsets(top: spacing / 2 + titleSize.height, left: -imageRect.width/2, bottom: 0, right: -imageRect.width/2)
    case .bottom:
      titleEdgeInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
      imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
      contentEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect.width/2, bottom: spacing / 2 + titleSize.height, right: -imageRect.width/2)
    case .left:
      titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
      imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
      contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
    case .right:
      titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
      imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
    }
  }
}
