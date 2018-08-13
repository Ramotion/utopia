import UIKit

public extension UICollectionView {
  
  /// Animate reload in a batch update
  ///
  /// - Parameters:
  ///   - changes: The changes from diff
  ///   - section: The section that all calculated IndexPath belong
  ///   - completion: Called when operation completes
  public func reload<T: Hashable>(
    changes: [Change<T>],
    section: Int = 0,
    calledInsideBatch: Bool = false,
    completion: @escaping (Bool) -> Void = { _ in }) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)

    if calledInsideBatch {
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
    } else {
      performBatchUpdates({
        internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
      }, completion: completion)
    }
  }


  /// Animate sections reload in a batch update
  ///
  /// - Parameters:
  ///   - changes: The changes from diff
  ///   - completion: Called when operation completes
  public func reloadSections<T: Hashable>(
    changes: [Change<T>],
    calledInsideBatch: Bool = false,
    completion: @escaping (Bool) -> Void = { _ in }) {

    let changesWithIndexSet = ChangeWithIndexSet(changes: changes)

    if calledInsideBatch {
      internalBatchUpdates(changesWithIndexSet: changesWithIndexSet)
    } else {
      performBatchUpdates({
        internalBatchUpdates(changesWithIndexSet: changesWithIndexSet)
      }, completion: completion)
    }
  }


  // MARK: - Helper
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath) {
    changesWithIndexPath.deletes.executeIfPresent {
      deleteItems(at: $0)
    }
    
    changesWithIndexPath.inserts.executeIfPresent {
      insertItems(at: $0)
    }
    
    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveItem(at: move.from, to: move.to)
      }
    }

    changesWithIndexPath.replaces.executeIfPresent {
      reloadItems(at: $0)
    }
  }

  private func internalBatchUpdates(changesWithIndexSet: ChangeWithIndexSet) {
    changesWithIndexSet.deletes.executeIfPresent {
      deleteSections($0)
    }

    changesWithIndexSet.inserts.executeIfPresent {
      insertSections($0)
    }

    changesWithIndexSet.moves.executeIfPresent {
      $0.forEach { move in
        moveSection(move.from, toSection: move.to)
      }
    }

    changesWithIndexSet.replaces.executeIfPresent {
      reloadSections($0)
    }
  }
}

