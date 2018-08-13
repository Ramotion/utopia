import Foundation

extension Collection {
  func executeIfPresent(_ closure: (Self) -> Void) {
    if !isEmpty {
      closure(self)
    }
  }
}

extension Array where Element == Int {
  var asIndexSet: IndexSet {
    return reduce(IndexSet()) { set, item in
      var set = set
      set.insert(item)
      return set
    }
  }
}
