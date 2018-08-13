//
//  SignalSubscription.swift
//  utopia
//
//  Created by Dmitriy Kalachev on 4/18/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import Foundation

/// A SignalLister represenents an instance and its association with a `Signal`.
final public class SignalSubscription<T> {
  public typealias SignalCallback = (T) -> Void
  public typealias SignalFilter = (T) -> Bool

  // The observer.
  weak public var observer: AnyObject?

  /// Whether the observer should be removed once it observes the `Signal` firing once. Defaults to false.
  public var once = false

  fileprivate var queuedData: T?
  var filter: (SignalFilter)?
  fileprivate var callback: SignalCallback
  fileprivate var dispatchQueue: DispatchQueue?
  private var sampleInterval: TimeInterval?

  init(observer: AnyObject, callback: @escaping SignalCallback) {
    self.observer = observer
    self.callback = callback
  }

  /// Assigns a filter to the `SignalSubscription`. This lets you define conditions under which a observer should actually
  /// receive the firing of a `Singal`. The closure that is passed an argument can decide whether the firing of a
  /// `Signal` should actually be dispatched to its observer depending on the data fired.
  ///
  /// If the closeure returns true, the observer is informed of the fire. The default implementation always
  /// returns `true`.
  ///
  /// - parameter predicate: A closure that can decide whether the `Signal` fire should be dispatched to its observer.
  /// - returns: Returns self so you can chain calls.
  @discardableResult
  public func filter(_ predicate: @escaping SignalFilter) -> SignalSubscription {
    self.filter = predicate
    return self
  }


  /// Tells the observer to sample received `Signal` data and only dispatch the latest data once the time interval
  /// has elapsed. This is useful if the subscriber wants to throttle the amount of data it receives from the
  /// `Singla`.
  ///
  /// - parameter sampleInterval: The number of seconds to delay dispatch.
  /// - returns: Returns self so you can chain calls.
  @discardableResult
  public func sample(every sampleInterval: TimeInterval) -> SignalSubscription {
    self.sampleInterval = sampleInterval
    return self
  }

  /// Assigns a dispatch queue to the `SignalSubscription`. The queue is used for scheduling the observer calls. If not
  /// nil, the callback is fired asynchronously on the specified queue. Otherwise, the block is run synchronously
  /// on the posting thread, which is its default behaviour.
  ///
  /// - parameter queue: A queue for performing the observer's calls.
  /// - returns: Returns self so you can chain calls.
  @discardableResult
  public func onQueue(_ queue: DispatchQueue) -> SignalSubscription {
    self.dispatchQueue = queue
    return self
  }

  /// Cancels the observer. This will cancelSubscription the listening object from the `Signal`.
  public func cancel() {
    self.observer = nil
  }

  // MARK: - Internal Interface

  func dispatch(data: T) -> Bool {
    guard observer != nil else {
      return false
    }

    if once {
      observer = nil
    }

    if let sampleInterval = sampleInterval {
      if queuedData != nil {
        queuedData = data
      } else {
        queuedData = data
        let block = { [weak self] () -> Void in
          if let definiteSelf = self {
            let data = definiteSelf.queuedData!
            definiteSelf.queuedData = nil
            if definiteSelf.observer != nil {
              definiteSelf.callback(data)
            }
          }
        }
        let dispatchQueue = self.dispatchQueue ?? DispatchQueue.main
        let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(sampleInterval * 1000))
        dispatchQueue.asyncAfter(deadline: deadline, execute: block)
      }
    } else {
      if let queue = self.dispatchQueue {
        queue.async {
          self.callback(data)
        }
      } else {
        callback(data)
      }
    }

    return observer != nil
  }
}

