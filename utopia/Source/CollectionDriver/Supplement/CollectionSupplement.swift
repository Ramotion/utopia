import UIKit

public class CollectionSupplement {

  var indexPath: IndexPath?
  weak var collectionView: UICollectionView?

  // MARK: - Blocks

  var sizeForConstraint: (CGSize) -> CGSize = { _ in fatalError() }
  var dequeueView: () -> UICollectionReusableView = { fatalError() }
  var didScroll: (UIScrollView) -> () = { _ in  }

  // MARK: -

  public init<T: CollectionSupplementProtocol>(_ controller: T) {
    sizeForConstraint = {
      return controller.sizeForConstraint($0)
    }

    dequeueView = { [unowned self] in
      guard let collectionView = self.collectionView,
        let indexPath = self.indexPath
        else { fatalError() }

      let view: T.View = collectionView.dequeueSupplement(kind: T.kind, for: indexPath)
      controller.fill(view)
      return view
    }
    
    didScroll = { scrollView in controller.didScroll(scrollView: scrollView) }
  }
}

