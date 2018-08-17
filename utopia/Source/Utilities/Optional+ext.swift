import Foundation

extension Optional {
  /**
   Attempts to unwrap the optional, and executes the closure if a value exists
   
   - parameter block: The closure to execute if a value is found
   */
  public func unwrap(_ block: (Wrapped) throws -> Void) rethrows {
    if let value = self {
      try block(value)
    }
  }
}
