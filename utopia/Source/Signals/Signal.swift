//
//  Copyright (c) 2014 - 2017 Tuomas Artman. All rights reserved.
//

import Foundation

/// Create instances of `Signal` and assign them to public constants on your class for each event type that your
/// class fires.
final public class Signal<T> {

  public typealias SignalCallback = (T) -> Void

  /// Whether or not the `Signal` should retain a reference to the last data it was fired with. Defaults to false.
  public var retainLastData: Bool = false {
    didSet {
      if !retainLastData {
        lastDataFired = nil
      }
    }
  }

  /// The last data that the `Signal` was fired with. In order for the `Signal` to retain the last fired data, its
  /// `retainLastFired`-property needs to be set to true
  public private(set) var lastDataFired: T? = nil

  /// All the observers of to the `Signal`.
  public var observers: [AnyObject] {
    return signalListeners.compactMap { $0.observer }
  }

  private var signalListeners = [SignalSubscription<T>]()


  // MARK: - Init

  /// Initializer.
  ///
  /// - parameter retainLastData: Whether or not the Signal should retain a reference to the last data it was fired
  ///   with. Defaults to false.
  public init(retainLastData: Bool = false) {
    self.retainLastData = retainLastData
  }


  // MARK: - Subscribe

  /// Subscribes an observer to the `Signal`.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  /// - returns: A `SignalSubscription` that can be used to cancel or filter the subscription.
  @discardableResult
  public func subscribe(with observer: AnyObject, callback: @escaping SignalCallback) -> SignalSubscription<T> {
    flushCancelledListeners()
    let signalListener = SignalSubscription<T>(observer: observer, callback: callback);
    signalListeners.append(signalListener)
    return signalListener
  }


  /// Subscribes an observer to the `Signal`. The subscription is automatically canceled after the `Signal` has
  /// fired once.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke when the signal fires for the first time.
  @discardableResult
  public func subscribeOnce(with observer: AnyObject, callback: @escaping SignalCallback) -> SignalSubscription<T> {
    let signalListener = self.subscribe(with: observer, callback: callback)
    signalListener.once = true
    return signalListener
  }

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the `Signal` fires.
  @discardableResult
  public func subscribePast(with observer: AnyObject, callback: @escaping SignalCallback) -> SignalSubscription<T> {
    #if DEBUG
    signalsAssert(retainLastData, "can't subscribe to past events on Signal with retainLastData set to false")
    #endif
    let signalListener = self.subscribe(with: observer, callback: callback)
    if let lastDataFired = lastDataFired {
      callback(lastDataFired)
    }
    return signalListener
  }

  /// Subscribes an observer to the `Signal` and invokes its callback immediately with the last data fired by the
  /// `Signal` if it has fired at least once and if the `retainLastData` property has been set to true. If it has
  /// not been fired yet, it will continue listening until it fires for the first time.
  ///
  /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
  ///   subscription is automatically cancelled.
  /// - parameter callback: The closure to invoke whenever the signal fires.
  @discardableResult
  public func subscribePastOnce(with observer: AnyObject, callback: @escaping SignalCallback) -> SignalSubscription<T> {
    #if DEBUG
    signalsAssert(retainLastData, "can't subscribe to past events on Signal with retainLastData set to false")
    #endif
    let signalListener = self.subscribe(with: observer, callback: callback)
    if let lastDataFired = lastDataFired {
      callback(lastDataFired)
      signalListener.cancel()
    } else {
      signalListener.once = true
    }
    return signalListener
  }


  // MARK: - Emit events

  /// Fires the `Singal`.
  ///
  /// - parameter data: The data to fire the `Signal` with.
  public func fire(_ data: T) {
    lastDataFired = retainLastData ? data : nil
    flushCancelledListeners()

    for signalListener in signalListeners {
      if signalListener.filter == nil || signalListener.filter!(data) == true {
        _ = signalListener.dispatch(data: data)
      }
    }
  }


  // MARK: - Cancel

  /// Cancels all subscriptions for an observer.
  ///
  /// - parameter observer: The observer whose subscriptions to cancel
  public func cancelSubscription(for observer: AnyObject) {
    signalListeners = signalListeners.filter {
      if let definiteListener:AnyObject = $0.observer {
        return definiteListener !== observer
      }
      return false
    }
  }

  /// Cancels all subscriptions for the `Signal`.
  public func cancelAllSubscriptions() {
    signalListeners.removeAll(keepingCapacity: false)
  }

  /// Clears the last fired data from the `Signal` and resets the fire count.
  public func clearLastData() {
    lastDataFired = nil
  }

  // MARK: - Private Interface

  private func flushCancelledListeners() {
    var removeListeners = false
    for signalListener in signalListeners {
      if signalListener.observer == nil {
        removeListeners = true
      }
    }
    if removeListeners {
      signalListeners = signalListeners.filter {
        return $0.observer != nil
      }
    }
  }
}

fileprivate func signalsAssert(_ condition: Bool, _ message: String) {
  #if DEBUG
  if let assertionHandlerOverride = assertionHandlerOverride {
    assertionHandlerOverride(condition, message)
    return
  }
  #endif
  assert(condition, message)
}

#if DEBUG
var assertionHandlerOverride:((_ condition: Bool, _ message: String) -> ())?
#endif
