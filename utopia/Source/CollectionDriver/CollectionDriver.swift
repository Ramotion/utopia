import UIKit
import SkeletonView

public class CollectionDriver {
  public private(set) var mode = DisplayMode.normal
  private var diffMode = DiffMode.immediate

  var willPerformBatchUpdate: ((UICollectionView) -> Void)? = nil
  var didPerformBatchUpdate: ((UICollectionView) -> Void)? = nil
  
  public var collectionView: UICollectionView? {
    didSet {
      sections.attachTo(collectionView, driver: self)

      if let collectionView = collectionView {
        collectionView.dataSource = wrapper
        collectionView.prefetchDataSource = wrapper
        collectionView.reloadData()
      }
    }
  }

  public var sections: [CollectionSection] {
    didSet {
      oldValue.attachTo(nil)
      sections.attachTo(collectionView, driver: self)

      enqueueDiff {
        let changes = diff(old: oldValue, new: self.sections)
        return .sections(changes)
      }
    }
  }

  public var emptyView: UIView

  var isShowingSkeleton: Bool {
    guard let collectionView = collectionView else { return false }
    return !(collectionView.dataSource is CollectionDataSourceWrapper)
  }

  private lazy var wrapper = CollectionDataSourceWrapper(collectionDriver: self)

  // MARK: -

  public init(sections: [CollectionSection] = [], emptyView: UIView = EmptyView.noData) {
    self.sections = sections
    self.emptyView = emptyView
  }
  
  // MARK: - Modes

  public func setLoadingMode(_ loadingMode: DisplayMode.LoadingMode) {
    self.mode = .loading(loadingMode)
    guard let collectionView = collectionView else { return }

    switch loadingMode {
    case .refreshControl:
      if let refreshControl = collectionView.refreshControl, !refreshControl.isRefreshing {
        refreshControl.beginRefreshing()
      }
    case .skeleton:
      hideError()
      collectionView.showSkeleton(usingColor: UIColor.unselected)
    }
  }

  public func refreshSkeleton() {
    guard let collectionView = collectionView else { return }
    collectionView.hideSkeleton()
    collectionView.alpha = 0
    delay(TimeInterval.oneFrame) {
      collectionView.showSkeleton(usingColor: UIColor.unselected)
      UIView.animate(withDuration: 0.2) {
        collectionView.alpha = 1
      }
    }
  }
  
  public func setNormalMode(_ closure: @escaping () -> Void = {}) {
    let oldMode = mode
    mode = .normal

    guard let collectionView = collectionView else { return }

    hideError()

    switch oldMode {
    case .loading(.skeleton):
      collectionView.hideSkeleton(reloadDataAfter: false)

      // Disable diffing to avoid crashes and stuff
      diffMode = .disabled

      closure()
      collectionView.reloadData()

      DispatchQueue.main.async {
        // Reload data completed so it's safe to enable diff again
        self.diffMode = .immediate
      }

    case .loading(.refreshControl):
      collectionView.refreshControl?.endRefreshing()
      fallthrough

    case .error, .normal:
      DispatchQueue.main.async {
        closure()
      }
    }

    DispatchQueue.main.async {
      collectionView.backgroundView = self.isEmpty ? self.emptyView : nil
    }
  }

  public func setErrorMode(_ error: Error) {
    let oldMode = mode
    mode = .error(error)

    guard let collectionView = collectionView else { return }

    switch oldMode {
    case .loading(.skeleton):
      collectionView.hideSkeleton(reloadDataAfter: false)

    case .loading(.refreshControl):
      collectionView.refreshControl?.endRefreshing()

    case .error, .normal:
      break
    }

    if let errorView = collectionView.backgroundView as? ErrorView {
      errorView.error = error
    } else {
      let errorView = ErrorView()
      errorView.error = error
      collectionView.backgroundView = errorView
    }
  }

  private func hideError() {
    collectionView?.backgroundView = nil
  }


  // MARK: - Diff

  public func batchUpdate(_ closure: () -> Void) {
    diffMode = .enqueue
    closure()

    if let collectionView = collectionView {
      willPerformBatchUpdate?(collectionView)
      collectionView.performBatchUpdates({
        diffQueue.forEach { applyDiffResult($0) }
        diffQueue = []
      }, completion: { [weak self] _ in
        guard let `self` = self, let collectionView = self.collectionView else { return }
        self.didPerformBatchUpdate?(collectionView)
      })
    }

    diffMode = .immediate
  }

  enum DiffResult {
    case items([Change<CollectionItem>], section: Int)
    case sections([Change<CollectionSection>])
  }
  
  private var diffQueue: [DiffResult] = []

  func enqueueDiff(_ calculateDiff: @escaping () -> DiffResult) {
    guard let collectionView = collectionView else { return }

    switch diffMode {
    case .immediate:
      willPerformBatchUpdate?(collectionView)
      collectionView.performBatchUpdates({
        applyDiffResult( calculateDiff() )
      }, completion: { [weak self] _ in
        guard let `self` = self, let collectionView = self.collectionView else { return }
        self.didPerformBatchUpdate?(collectionView)
      })
    case .enqueue:
      diffQueue.append( calculateDiff() )

    case .disabled:
      break
    }
  }

  private func applyDiffResult(_ result: DiffResult) {
    guard let collectionView = collectionView else { return }
    switch result {
    case let .items(changes, section: sectionIndex):
      collectionView.reload(changes: changes, section: sectionIndex, calledInsideBatch: true)

    case let .sections(changes):
      collectionView.reloadSections(changes: changes, calledInsideBatch: true)
    }
  }


  // MARK: - Data

  public var isEmpty: Bool {
    return sections.reduce(0, { $0 + $1.items.count }) == 0
  }

  public func item(at indexPath: IndexPath) -> CollectionItem {
    return sections[indexPath.section].items[indexPath.item]
  }

  public func safeItem(at indexPath: IndexPath) -> CollectionItem? {
    guard indexPath.section < sections.endIndex,
      indexPath.item < sections[indexPath.section].items.endIndex
      else { return nil }
    return sections[indexPath.section].items[indexPath.item]
  }

  public func supplement(ofKind: String, at indexPath: IndexPath) -> CollectionSupplement? {
    return sections[indexPath.section].supplementaryItems[ofKind]?[indexPath.item]
  }

}


// MARK: - Mode Definition

extension CollectionDriver {
  public enum DisplayMode {
    case normal
    case loading(LoadingMode)
    case error(Error)

    public enum LoadingMode {
      case refreshControl
      case skeleton
    }
  }

  enum DiffMode {
    case immediate
    case enqueue
    case disabled
  }
}


// MARK: - Wrapper

private final class CollectionDataSourceWrapper: NSObject, SkeletonCollectionViewDataSource, UICollectionViewDataSourcePrefetching {

  unowned let collectionDriver: CollectionDriver

  init(collectionDriver: CollectionDriver) {
    self.collectionDriver = collectionDriver
  }


  // MARK: Data Source

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return collectionDriver.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionDriver.sections[section].items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionDriver.item(at: indexPath).dequeueCell()
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if let supplement = collectionDriver.supplement(ofKind: kind, at: indexPath) {
      return supplement.dequeueView()
    } else {
      return UICollectionReusableView()
    }
  }


  // MARK: Skeleton

  func numSections(in collectionSkeletonView: UICollectionView) -> Int {
    return collectionDriver.sections.count
  }

  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return collectionDriver.sections[indexPath.section].skeletonCellIdentifier.require(hint: "Specify skeleton cell")
  }
  
  func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let count = collectionDriver.sections[section].skeletonCellsCount {
      return count
    } else if let collection = collectionDriver.collectionView,
              let flowlayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
      let count = Int(ceil(collection.frame.height/flowlayout.itemSize.height))
      return count
    } else {
      return 0
    }
  }


  // MARK: Prefetch

  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    guard !collectionDriver.isShowingSkeleton else { return }
    indexPaths.forEach {
      collectionDriver
        .safeItem(at: $0)? // indexPaths contains non-existing items if updating
        .prefetch()
    }
  }

  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    guard !collectionDriver.isShowingSkeleton else { return }
    indexPaths.forEach {
      collectionDriver
        .safeItem(at: $0)?
        .cancelPrefetch()
    }
  }
}


// MARK: - Private extensions

private extension Array where Element: CollectionSection {
  func attachTo(_ collectionView: UICollectionView?, driver: CollectionDriver? = nil) {
    if let collectionView = collectionView {
      enumerated().forEach {
        $1.attach(to: collectionView, at: $0)
        $1.driver = driver
      }
    } else {
      forEach { $0.detach() }
    }
  }
}

