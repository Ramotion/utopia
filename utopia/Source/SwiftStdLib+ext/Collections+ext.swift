//
//  Collections+ext.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/11/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import Foundation

public extension Collection {
  var isNotEmpty: Bool {
    return !isEmpty
  }
}

public extension Dictionary {
  func mapKeys<T>(_ transform: (Key) -> T) -> Dictionary<T, Value> {
    var result = Dictionary<T, Value>()
    result.reserveCapacity(count)
    self.forEach { key, value in
      result[transform(key)] = value
    }
    return result
  }

  func merging(_ other: [Key: Value]) -> [Key: Value] {
    return merging(other, uniquingKeysWith: { l,r in r })
  }
}

public extension Optional where Wrapped: Collection {
  var isNilOrEmpty: Bool {
    switch self {
    case let collection?:
      return collection.isEmpty
    case nil:
      return true
    }
  }
}

extension Array {
  func chunk(_ chunkSize: Int) -> [[Element]] {
    return stride(from: 0, to: self.count, by: chunkSize).map({ (startIndex) -> [Element] in
      let endIndex = (startIndex.advanced(by: chunkSize) > self.count) ? self.count-startIndex : chunkSize
      return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
    })
  }
}

extension Collection where Self.Index == Self.Indices.Iterator.Element {
  /**
   Returns an optional element. If the `index` does not exist in the collection, the subscript returns nil.
   
   - parameter safe: The index of the element to return, if it exists.
   
   - returns: An optional element from the collection at the specified index.
   */
  public subscript(safe i: Index) -> Self.Iterator.Element? {
    return at(i)
  }
  
  /**
   Returns an optional element. If the `index` does not exist in the collection, the function returns nil.
   
   - parameter index: The index of the element to return, if it exists.
   
   - returns: An optional element from the collection at the specified index.
   */
  public func at(_ i: Index) -> Self.Iterator.Element? {
    return indices.contains(i) ? self[i] : nil
  }
}


public extension MutableCollection where Index == Int {
  
  /**
   Returns a random element from the collection.
   - returns: A random element from the collection.
   */
  func random() -> Iterator.Element {
    let index = Int(arc4random_uniform(UInt32(count)))
    return self[index]
  }
}

extension Array {
  public mutating func removeObject<T: Equatable>(_ obj: T) {
    self = self.filter({ $0 as? T != obj })
  }
}
