import UIKit

public protocol CollectionSupplementProtocol {
  associatedtype View: UICollectionReusableView
  static var kind: String { get }
  func sizeForConstraint(_ constraint: CGSize) -> CGSize
  func fill(_ view: View)
  func didScroll(scrollView: UIScrollView)
}

public extension CollectionSupplementProtocol {
  static func registerReusable(in collectionView: UICollectionView) {
    collectionView.registerSupplement(View.self, kind: kind)
  }

  var supplementaryItem: CollectionSupplement {
    return CollectionSupplement(self)
  }
  
  // default implementation
  func didScroll(scrollView: UIScrollView) { }
}
