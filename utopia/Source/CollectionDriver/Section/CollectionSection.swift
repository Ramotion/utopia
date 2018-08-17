import UIKit
import SkeletonView

public class CollectionSection: Hashable, Then {

  private var sectionIndex: Int?
  private weak var collectionView: UICollectionView?
  weak var driver: CollectionDriver?


  // MARK: - Data

  public var items: [CollectionItem] {
    didSet {
      oldValue.attachTo(nil, sectionIndex: nil)
      items.attachTo(collectionView, sectionIndex: sectionIndex)

      if let collectionView = collectionView,
        let sectionIndex = sectionIndex,
        let driver = driver
      {
        driver.enqueueDiff {
          // Call fill for visible cells so bindings are set because
          // CollectionItem are always recreated.
          collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard indexPath.section == sectionIndex else { return }
            
            if indexPath.item < self.items.endIndex {
              self.items[indexPath.item].fillCell()
            }
          }

          // Calculate
          let changes = diff(old: oldValue, new: self.items)
          return .items(changes, section: sectionIndex)
        }
      }
    }
  }

  public var supplementaryItems: [String: [CollectionSupplement]] = [:] {
    didSet {
      supplementaryItems.values.forEach {
        $0.attachTo(collectionView, sectionIndex: sectionIndex)
      }
    }
  }

  public let identifier: String


  // MARK: - Skeleton

  public var skeletonCellIdentifier: ReusableCellIdentifier?
  public var skeletonSizeForConstraint: ((CGSize) -> CGSize)?
  public var skeletonCellsCount: Int? 

  // MARK: - Init

  public init(identifier: String = ProcessInfo.processInfo.globallyUniqueString, items: [CollectionItem] = []) {
    self.identifier = identifier
    self.items = items
  }


  // MARK: -

  func attach(to collectionView: UICollectionView, at index: Int) {
    self.collectionView = collectionView
    self.sectionIndex = index
    items.attachTo(collectionView, sectionIndex: index)
    supplementaryItems.values.forEach {
      $0.attachTo(collectionView, sectionIndex: index)
    }
  }

  func detach() {
    collectionView = nil
    sectionIndex = nil
    items.attachTo(nil, sectionIndex: nil)
    supplementaryItems.values.forEach {
      $0.attachTo(nil, sectionIndex: nil)
    }
  }


  // MARK: - Hashable

  public var hashValue: Int {
    return identifier.hashValue
  }

  public static func == (lhs: CollectionSection, rhs: CollectionSection) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.items == rhs.items
  }
}


// MARK: -

private extension Array where Element: CollectionItem {
  func attachTo(_ collectionView: UICollectionView?, sectionIndex: Int?) {
    enumerated().forEach { index, item in
      item.collectionView = collectionView
      item.indexPath = sectionIndex.map { IndexPath(item: index, section: $0) }
    }
  }
}

private extension Array where Element: CollectionSupplement {
  func attachTo(_ collectionView: UICollectionView?, sectionIndex: Int?) {
    enumerated().forEach { index, item in
      item.collectionView = collectionView
      item.indexPath = sectionIndex.map { IndexPath(item: index, section: $0) }
    }
  }
}

