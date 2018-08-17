import UIKit

public struct CollectionItemEvents<Data> {
  public var dataUpdated: (Data) -> Void = { _ in }
  public var dataAndSizeUpdated: (Data) -> Void = { _ in }
  public var animatedSizeUpdated: () -> Void = {  }
  public init() { }
}

public protocol CollectionItemProtocol: class {
  associatedtype Cell: UICollectionViewCell
  associatedtype Data: Hashable

  // Data-related
  var data: Data { get }

  // Cell-related
  func fillCell(_ cell: Cell, animated: Bool)
  func size(constrainedTo width: CGFloat, height: CGFloat) -> CGSize
  func cellWillDisplay(_ cell: Cell)
  func cellSelected(_ cell: Cell)

  // Events to pass to collection driver
  var events: CollectionItemEvents<Data> { get set }

  // Prefetching
  func prefetchContent()
  func cancelPrefetchContent()
}

public extension CollectionItemProtocol {
  static func registerReusableCell(in collectionView: UICollectionView) {
    collectionView.registerCell(Cell.self)
  }

  var collectionItem: CollectionItem {
    return CollectionItem(self)
  }

  func singleItemSection(_ identifier: String = ProcessInfo.processInfo.globallyUniqueString) -> CollectionSection {
    return CollectionSection(identifier: identifier, items: [ self.collectionItem ])
  }

  // MARK: -  Default implementations

  func prefetchContent() { }
  func cancelPrefetchContent() { }
  func cellWillDisplay(_ cell: Cell) { }
  func cellSelected(_ cell: Cell) { }
}
