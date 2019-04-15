import Foundation
import UIKit


final class SnappingFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        switch scrollDirection {
        case .horizontal:
            let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
            
            let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            
            let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
            
            layoutAttributesArray?.forEach { layoutAttributes in
                let itemOffset = layoutAttributes.frame.origin.x
                if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                    offsetAdjustment = itemOffset - horizontalOffset
                }
            }
            let result = CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
            return result
            
        case .vertical:
            let verticalOffset = proposedContentOffset.y + collectionView.contentInset.top
            
            let targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            
            let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
            layoutAttributesArray?.forEach { layoutAttributes in
                let itemOffset = layoutAttributes.frame.origin.y
                if fabsf(Float(itemOffset - verticalOffset)) < fabsf(Float(offsetAdjustment)) {
                    offsetAdjustment = itemOffset - verticalOffset
                }
            }
            
            let result = CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
            return result
        @unknown default:
          fatalError()
      }
    }
}
