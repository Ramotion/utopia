import Foundation
import UIKit

public final class HorizontalAlignmentLayout: UICollectionViewFlowLayout {
    
    // KVO
    fileprivate struct KVO {
        
        var keyPath: String
        var options: NSKeyValueObservingOptions
        var context: Int
        
        static var contentOffset = KVO(
            keyPath: #keyPath(UICollectionViewFlowLayout.collectionView.contentOffset),
            options: .new,
            context: 0
        )
        
        static var bounds = KVO(
            keyPath: #keyPath(UICollectionViewFlowLayout.collectionView.bounds),
            options: .new,
            context: 1
        )
    }
    
    public enum Alignment {
        case left
        case center
        case right
    }
    
    // Properties
    public var currentPage: Int?
    public var currentPageDidChange: (Int) -> Void = { _ in }
    let alignment: Alignment
    
    var collectionWidth: CGFloat {
        guard let collection = collectionView else { return 0 }
        return collection.bounds.size.width - collection.contentInset.right - collection.contentInset.left
    }
    
    deinit {
        removeObserver(self, forKeyPath: KVO.bounds.keyPath, context: &KVO.bounds.context)
    }
    
    public init(itemSize: CGSize, spacing: CGFloat, alignment: Alignment) {
        self.alignment = alignment
        super.init()
        self.itemSize = itemSize
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = spacing
        
        addObserver(self,
                    forKeyPath: KVO.bounds.keyPath,
                    options: KVO.bounds.options,
                    context: &KVO.bounds.context)
        
        addObserver(self,
                    forKeyPath: KVO.contentOffset.keyPath,
                    options: KVO.contentOffset.options,
                    context: &KVO.contentOffset.context)
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: override
extension HorizontalAlignmentLayout {
    
    public override func prepare() {
        switch alignment {
        case .left:
            sectionInset.left = 0
            sectionInset.right = collectionWidth - itemSize.width
        case .center:
            let inset = (collectionWidth - itemSize.width) / 2
            sectionInset.left = inset
            sectionInset.right = inset
        case .right:
            sectionInset.right = 0
            sectionInset.left = collectionWidth - itemSize.width
        }
        super.prepare()
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else {
            return proposedContentOffset
        }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetX: CGFloat
        switch alignment {
        case .left:
            proposedContentOffsetX = proposedContentOffset.x + itemSize.width / 2
        case .center:
            proposedContentOffsetX = proposedContentOffset.x + collectionView.bounds.width / 2
        case .right:
            proposedContentOffsetX = proposedContentOffset.x + collectionView.bounds.width
        }
        
        for attributes in layoutAttributes {
            guard attributes.representedElementCategory == .cell else { continue }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            let attributePosition: CGFloat
            let candidatePosition: CGFloat
            switch alignment {
            case .left:
                attributePosition = attributes.frame.minX
                candidatePosition = candidateAttributes!.frame.minX
            case .center:
                attributePosition = attributes.center.x
                candidatePosition = candidateAttributes!.center.x
            case .right:
                attributePosition = attributes.frame.maxX
                candidatePosition = candidateAttributes!.frame.maxX
            }
            
            if abs(attributePosition - proposedContentOffsetX) < abs(candidatePosition - proposedContentOffsetX) {
                candidateAttributes = attributes
            }
        }
        
        guard let aCandidateAttributes = candidateAttributes else {
            return proposedContentOffset
        }
        
        var newOffsetX: CGFloat
        switch alignment {
        case .left:
            newOffsetX = aCandidateAttributes.frame.minX - collectionView.contentInset.left
        case .center:
            newOffsetX = aCandidateAttributes.center.x - collectionView.bounds.size.width / 2
        case .right:
            newOffsetX = aCandidateAttributes.frame.minX - collectionView.bounds.size.width + itemSize.width
        }
        
        let offset = newOffsetX - collectionView.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = itemSize.width + minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch context {
        case (&KVO.bounds.context)?:
            // TODO: Current layout makes hack for first item to appear in the center.
            // (method configure Insets). Settings insets shouldn't be done in invalidateLayout.
            // Layout should handle appear state on it's own.
            let oldValue = change?[.oldKey] as? NSValue
            let newValue = change?[.newKey] as? NSValue
            if oldValue?.cgRectValue != newValue?.cgRectValue {
                invalidateLayout()
            }
            
        case (&KVO.contentOffset.context)?:
            guard let collectionView = collectionView, collectionView.frame.size != CGSize.zero else {
                return
            }
            
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
            let layoutAttributes = layoutAttributesForElements(in: visibleRect)
            
            let center: CGFloat
            switch alignment {
            case .left:
                let middle = collectionView.contentInset.left + itemSize.width / 2
                center = collectionView.contentOffset.x + middle
            case .center:
                let middle = collectionView.frame.width / 2
                center = collectionView.contentOffset.x + middle
            case .right:
                let middle = collectionView.frame.width - collectionView.contentInset.right - itemSize.width / 2
                center = collectionView.contentOffset.x + middle
            }
            
            let closestAttribute = layoutAttributes?.sorted {
                abs($0.center.x - center) < abs($1.center.x - center)
            }.first
            if let closestAttribute = closestAttribute, currentPage != closestAttribute.indexPath.row {
                currentPage = closestAttribute.indexPath.row
                if let currentPage = currentPage {
                    currentPageDidChange(currentPage)
                }
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
