import Foundation
import UIKit

public final class VerticalAlignmentLayout: UICollectionViewFlowLayout {
    
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
        case top
        case center
        case bottom
    }
    
    // Properties
    public var currentPage: Int?
    public var currentPageDidChange: (Int) -> Void = { _ in }
    let alignment: Alignment
    
    var collectionHeight: CGFloat {
        guard let collection = collectionView else { return 0 }
        return collection.bounds.size.height - collection.contentInset.top - collection.contentInset.bottom
    }
    
    deinit {
        removeObserver(self, forKeyPath: KVO.bounds.keyPath, context: &KVO.bounds.context)
    }
    
    public init(itemSize: CGSize, spacing: CGFloat, alignment: Alignment) {
        self.alignment = alignment
        super.init()
        self.itemSize = itemSize
        self.scrollDirection = .vertical
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
extension VerticalAlignmentLayout {
    
    public override func prepare() {
        switch alignment {
        case .top:
            sectionInset.top = 0
            sectionInset.bottom = collectionHeight - itemSize.height
        case .center:
            let inset = (collectionHeight - itemSize.height) / 2
            sectionInset.top = inset
            sectionInset.bottom = inset
        case .bottom:
            sectionInset.top = collectionHeight - itemSize.height
            sectionInset.bottom = 0
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
        let proposedContentOffsetY: CGFloat
        switch alignment {
        case .top:
            proposedContentOffsetY = proposedContentOffset.y + itemSize.height / 2
        case .center:
            proposedContentOffsetY = proposedContentOffset.y + collectionView.bounds.height / 2
        case .bottom:
            proposedContentOffsetY = proposedContentOffset.y + collectionView.bounds.height
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
            case .top:
                attributePosition = attributes.frame.minY
                candidatePosition = candidateAttributes!.frame.minY
            case .center:
                attributePosition = attributes.center.y
                candidatePosition = candidateAttributes!.center.y
            case .bottom:
                attributePosition = attributes.frame.maxY
                candidatePosition = candidateAttributes!.frame.maxY
            }
            
            if abs(attributePosition - proposedContentOffsetY) < abs(candidatePosition - proposedContentOffsetY) {
                candidateAttributes = attributes
            }
        }
        
        guard let aCandidateAttributes = candidateAttributes else {
            return proposedContentOffset
        }
        
        var newOffsetY: CGFloat
        switch alignment {
        case .top:
            newOffsetY = aCandidateAttributes.frame.minY - collectionView.contentInset.top
        case .center:
            newOffsetY = aCandidateAttributes.center.y - collectionView.bounds.size.height / 2
        case .bottom:
            newOffsetY = aCandidateAttributes.frame.minY - collectionView.bounds.size.height + itemSize.width
        }
        
        let offset = newOffsetY - collectionView.contentOffset.y
        
        if (velocity.y < 0 && offset > 0) || (velocity.y > 0 && offset < 0) {
            let pageHeight = itemSize.height + minimumLineSpacing
            newOffsetY += velocity.y > 0 ? pageHeight : -pageHeight
        }
        
        return CGPoint(x: proposedContentOffset.x, y: newOffsetY)
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
            case .top:
                let middle = collectionView.contentInset.top + itemSize.height / 2
                center = collectionView.contentOffset.y + middle
            case .center:
                let middle = collectionView.frame.height / 2
                center = collectionView.contentOffset.y + middle
            case .bottom:
                let middle = collectionView.frame.height - collectionView.contentInset.bottom - itemSize.height / 2
                center = collectionView.contentOffset.y + middle
            }
            
            let closestAttribute = layoutAttributes?.sorted {
                abs($0.center.y - center) < abs($1.center.y - center)
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
