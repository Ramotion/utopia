import UIKit

public class CollectionFlowDelegate: CollectionDelegate, UICollectionViewDelegateFlowLayout {

  public var defaultLayout: Layout
  private var layouts: [CollectionSection: Layout] = [:]

  var flowLayout: UICollectionViewFlowLayout {
    guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
      fatalError("CollectionFlowDelegate can manage only collections with flow layout")
    }
    return layout
  }


  // MARK: - Init

  public init(driver: CollectionDriver, defaultLayout: Layout = Layout()) {
    self.defaultLayout = defaultLayout
    super.init(driver: driver)
  }


  // MARK: - Section Layouts

  public func layoutForSection(_ section: CollectionSection) -> Layout {
    if let layout = layouts[section] {
      return layout
    }

    layouts[section] = defaultLayout
    return defaultLayout
  }

  func layoutForSection(_ index: Int) -> Layout {
    return layoutForSection(collectionDriver.sections[index])
  }

  public func configureLayout(for section: CollectionSection, closure: (inout Layout) -> Void) {
    layouts[section] = layoutForSection(section).with(closure)
  }


  // MARK: - Delegate

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let layout = layoutForSection(indexPath.section)
    let constraint = layout.itemConstraints(layout: flowLayout)
    if collectionDriver.isShowingSkeleton {
      if let itemSizeFor = collectionDriver.sections[indexPath.section].skeletonSizeForConstraint {
      let itemSize = itemSizeFor(constraint)
        return itemSize
      } else {
        return CGSize.zero
      }
    } else {
      let itemSize = collectionDriver.item(at: indexPath).sizeForConstraint(constraint)
      return itemSize
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return layoutForSection(section).lineSpacing
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return layoutForSection(section).interitemSpacing
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return layoutForSection(section).insets
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    let constraint = layoutForSection(section).supplementConstraints(layout: flowLayout)
    return collectionDriver.sections[section].header?.sizeForConstraint(constraint) ?? .zero
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    
    let constraint = layoutForSection(section).supplementConstraints(layout: flowLayout)
    return collectionDriver.sections[section].footer?.sizeForConstraint(constraint) ?? .zero
  }

}


// MARK: - Layout

extension CollectionFlowDelegate {

  public struct Layout: Then {
    public var itemsPerRow: Int = 1
    public var lineSpacing: CGFloat = 0
    public var interitemSpacing: CGFloat = 0
    public var insets: UIEdgeInsets = .zero

    public init() {}

    func supplementConstraints(layout: UICollectionViewFlowLayout) -> CGSize {
      switch layout.scrollDirection {
      case .vertical:   return CGSize(layout.collectionViewWidth, 0)
      case .horizontal: return CGSize(0, layout.collectionViewHeight)
      }
    }

    func itemConstraints(layout: UICollectionViewFlowLayout) -> CGSize {
      switch layout.scrollDirection {
      case .vertical:
        let width = (layout.collectionViewWidth - (
          CGFloat(itemsPerRow - 1) * interitemSpacing
            + insets.left
            + insets.right
        )) / CGFloat(itemsPerRow)
        return CGSize(width, 0)

      case .horizontal:
        let height = (layout.collectionViewHeight - (
          CGFloat(itemsPerRow - 1) * interitemSpacing
            + insets.top
            + insets.bottom
        )) / CGFloat(itemsPerRow)
        return CGSize(0, height)
      }
    }
  }
}


// MARK: -

public extension CollectionSection {
  public var header: CollectionSupplement? {
    get {
      return supplementaryItems[UICollectionElementKindSectionHeader]?.first
    }
    set {
      supplementaryItems[UICollectionElementKindSectionHeader]
        = newValue == nil ? [] : [newValue!]
    }
  }

  public var footer: CollectionSupplement? {
    get {
      return supplementaryItems[UICollectionElementKindSectionFooter]?.first
    }
    set {
      supplementaryItems[UICollectionElementKindSectionFooter]
        = newValue == nil ? [] : [newValue!]
    }
  }
}

extension UICollectionViewFlowLayout {
  var collectionViewWidth: CGFloat { return collectionView?.bounds.width ?? 0 }
  var collectionViewHeight: CGFloat { return collectionView?.bounds.height ?? 0 }
}
