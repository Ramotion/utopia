import UIKit

public class CollectionItem: Hashable {

  private(set) public var data: AnyHashable
  private let cellClass: AnyClass
  var indexPath: IndexPath?
  weak var collectionView: UICollectionView?


  // MARK: - Blocks

  var dequeueCell: () -> UICollectionViewCell = { fatalError() }
  var fillCell: () -> Void = {}
  let prefetch: () -> Void
  let cancelPrefetch: () -> Void 
  let willDisplay: (UICollectionViewCell) -> Void
  let didSelect: (UICollectionViewCell) -> Void
  var sizeForConstraint: (CGSize) -> CGSize = { _ in fatalError() }

  public init<T: CollectionItemProtocol>(_ controller: T) {
    cellClass = T.Cell.self
    data = AnyHashable(controller.data)

    willDisplay = {
      if let cell = $0 as? T.Cell {
        controller.cellWillDisplay(cell)
      }
    }

    didSelect = {
      if let cell = $0 as? T.Cell {
        controller.cellSelected(cell)
      }
    }

    prefetch = controller.prefetchContent
    cancelPrefetch = controller.cancelPrefetchContent

    dequeueCell = { [unowned self] in
      guard let indexPath = self.indexPath,
        let collectionView = self.collectionView
        else { fatalError() }

      let cell: T.Cell = collectionView.dequeueCell(for: indexPath)
      controller.fillCell(cell, animated: false)
      return cell
    }

    fillCell = { [weak self] in
      DispatchQueue.main.async { [weak self] in
        guard let `self` = self, let indexPath = self.indexPath, let collectionView = self.collectionView else { return }
        if let cell = collectionView.cellForItem(at: indexPath) as? T.Cell {
          controller.fillCell(cell, animated: true)
        }
      }
    }

    sizeForConstraint = {
      return controller.size(constrainedTo: $0.width, height: $0.height)
    }

    controller.events.dataUpdated = { [unowned self] newData in
      self.data = newData
      self.fillCell()
    }
    
    controller.events.dataAndSizeUpdated = { [unowned self] newData in
      self.data = newData
      guard let indexPath = self.indexPath,
        let collectionView = self.collectionView
        else { return }
      UIView.performWithoutAnimation {
        collectionView.reloadItems(at: [ indexPath ])
      }
    }
    
    controller.events.animatedSizeUpdated = { [unowned self] in
      self.collectionView?.performBatchUpdates({}, completion: nil)
    }
  }


  // MARK: - Hashable

  public var hashValue: Int {
    return data.hashValue
  }

  public static func == (lhs: CollectionItem, rhs: CollectionItem) -> Bool {
    return lhs.cellClass == rhs.cellClass && lhs.data == rhs.data
  }

}
