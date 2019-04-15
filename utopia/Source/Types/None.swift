import Foundation

public let none = None()

public struct None {}

extension None: Hashable {
  
  public func hash(into hasher: inout Hasher) { }
}

public func == (lhs: None, rhs: None) -> Bool { return true }
