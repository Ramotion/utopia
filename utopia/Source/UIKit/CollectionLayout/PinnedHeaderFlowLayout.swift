import Foundation
import UIKit

public final class PinnedHeaderFlowLayout: UICollectionViewFlowLayout {
    
    private let header = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(row: 0, section: 0))
    private var headerSize: CGSize = .zero
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }
        let attributes = super.layoutAttributesForElements(in: rect)
        
        let headerAttributes = attributes?.filter { $0.isFirstHeader }.first
        if let headerAttributes = headerAttributes {
            headerSize = headerAttributes.size
        }
        
        if collectionView.contentOffset.y > 0 {
            header.frame.origin.y = collectionView.contentOffset.y
        } else {
            header.frame.origin.y = 0
        }
        
        var newAttribures = attributes?.filter { !$0.isFirstHeader }
        header.frame.size = headerSize
        header.zIndex = Int.max
        newAttribures?.append(header)
        
        return newAttribures
    }
}


private extension UICollectionViewLayoutAttributes {
    var isFirstHeader: Bool {
        guard let elementKind = representedElementKind else { return false }
        return (elementKind == UICollectionView.elementKindSectionHeader && indexPath.section == 0)
    }
}
