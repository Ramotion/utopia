import Foundation

public struct SimpleError: Error, LocalizedError {
  let message: String
  
  public init(_ message: String) {
    self.message = message
  }

  public var errorDescription: String? {
    return message
  }
}
