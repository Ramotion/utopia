import Foundation

private class Associated<T>: NSObject {
  let value: T
  init(_ value: T) {
    self.value = value
  }
}

protocol Associable {}

extension Associable where Self: AnyObject {
  
  func getAssociatedObject<T>(_ key: UnsafeRawPointer) -> T? {
    return (objc_getAssociatedObject(self, key) as? Associated<T>).map { $0.value }
  }
  
  func setAssociatedObject<T>(_ key: UnsafeRawPointer, _ value: T?) {
    objc_setAssociatedObject(self, key, value.map { Associated<T>($0) }, .OBJC_ASSOCIATION_RETAIN)
  }
  
}

extension NSObject: Associable {}
