import Foundation

public struct ChangeWithIndexSet {

  public let inserts: IndexSet
  public let deletes: IndexSet
  public let replaces: IndexSet
  public let moves: [(from: Int, to: Int)]

  public init(
    inserts: IndexSet,
    deletes: IndexSet,
    replaces: IndexSet,
    moves: [(from: Int, to: Int)]) {

    self.inserts = inserts
    self.deletes = deletes
    self.replaces = replaces
    self.moves = moves
  }

  public init<T>(changes: [Change<T>]) {
    inserts = changes
      .compactMap { $0.insert?.index }
      .asIndexSet

    deletes = changes
      .compactMap { $0.delete?.index }
      .asIndexSet

    replaces = changes
      .compactMap { $0.replace?.index }
      .asIndexSet

    moves = changes
      .compactMap { $0.move }
      .map { (from: $0.fromIndex, to: $0.toIndex) }
  }
}
