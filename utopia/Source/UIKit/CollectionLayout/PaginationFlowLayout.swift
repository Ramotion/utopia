import UIKit

public class PaginationFlowLayout: UICollectionViewFlowLayout {
  
  override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    
    guard let collectionView = collectionView,
      let layoutAttributes: Array = layoutAttributesForElements(in: collectionView.bounds),
      layoutAttributes.count != 0 else {
        return proposedContentOffset
    }
    
    var firstAttribute: UICollectionViewLayoutAttributes = layoutAttributes[0]
    for attribute: UICollectionViewLayoutAttributes in layoutAttributes {
      guard attribute.representedElementCategory == .cell else { continue }
      
      switch scrollDirection {
      case .horizontal:
        if((velocity.x > 0.0 && attribute.center.x > firstAttribute.center.x) ||
          (velocity.x <= 0.0 && attribute.center.x < firstAttribute.center.x)) {
          firstAttribute = attribute;
        }
      case .vertical:
        if((velocity.y > 0.0 && attribute.center.y > firstAttribute.center.y) ||
          (velocity.y <= 0.0 && attribute.center.y < firstAttribute.center.y)) {
          firstAttribute = attribute;
        }
      }
    }
    
    switch scrollDirection {
    case .horizontal:
      return CGPoint(x: firstAttribute.center.x - collectionView.bounds.size.width * 0.5, y: proposedContentOffset.y)
    case .vertical:
      return CGPoint(x: proposedContentOffset.x, y: firstAttribute.center.y - collectionView.bounds.size.height * 0.5)
    }
  }
}
