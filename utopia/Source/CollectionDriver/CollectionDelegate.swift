import UIKit

open class CollectionDelegate: NSObject, UICollectionViewDelegate {

  weak var scrollViewDelegate: UIScrollViewDelegate?
  
  public weak var collectionView: UICollectionView? {
    didSet {
      collectionView?.delegate = self
    }
  }

  public let collectionDriver: CollectionDriver

  public init(driver: CollectionDriver) {
    self.collectionDriver = driver
    super.init()
  }

  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard !collectionDriver.isShowingSkeleton else { return }
    collectionDriver.item(at: indexPath).willDisplay(cell)
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    collectionDriver.item(at: indexPath).didSelect(cell)
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    
    for section in 0..<collectionDriver.sections.count {
      let indexPath = IndexPath(item: 0, section: section)
      collectionDriver.supplement(ofKind: UICollectionElementKindSectionHeader, at: indexPath)?.didScroll(scrollView)
      collectionDriver.supplement(ofKind: UICollectionElementKindSectionFooter, at: indexPath)?.didScroll(scrollView)
    }
  }
  
  public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewDidZoom?(scrollView)
  }
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
  }
  
  public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
  }
  
  public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
  }
  
  public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
  }
  
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return scrollViewDelegate?.viewForZooming?(in: scrollView)
  }
  
  public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
  }
  
  public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
  }
  
  public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    return scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
  }
  
  public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
  }
}
