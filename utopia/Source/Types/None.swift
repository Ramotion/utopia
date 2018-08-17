import Foundation

public let none = None()

public struct None {}

extension None: Hashable {
  public var hashValue: Int {
    return 0
  }
}

public func == (lhs: None, rhs: None) -> Bool { return true }
