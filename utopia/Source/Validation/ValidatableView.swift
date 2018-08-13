//
//  ValidatableView.swift
//  utopia
//
//  Created by Dmitriy Kalachev on 4/18/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import Foundation

public protocol ValidationDisplay: class {
  var validationResult: ValidationResult { get }
  var viewValidationState: ViewValidationState { get set }
  func showValidationResult()
}

public extension Array where Element == ValidationDisplay {
  var isAllValid: Bool {
    return reduce(true, { $0 && $1.validationResult.isValid })
  }
}

public protocol ValidatableView: ValidationDisplay {
  associatedtype Value
  var value: Value { get set }
  var valueChanged: (Value) -> Void { get set }
  var validator: Validator<Value>? { get set }
}

public extension ValidatableView {
  var validationResult: ValidationResult {
    return validator?.validate(value) ?? .valid
  }
  func showValidationResult() {
    viewValidationState = ViewValidationState(validationResult)
  }
}

public enum ViewValidationState: Equatable {
  case empty
  case valid
  case invalid(String)

  public init(_ result: ValidationResult) {
    switch result {
    case .valid:            self = .valid
    case .invalid(let msg): self = .invalid(msg)
    }
  }

  public var isInvalid: Bool {
    switch self {
    case .invalid:  return true
    default:        return false
    }
  }

  public var isValid: Bool {
    switch self {
    case .valid:  return true
    default:      return false
    }
  }
  
  public var isEmpty: Bool {
    switch self {
    case .empty:  return true
    default:      return false
    }
  }

  public var errorMessage: String? {
    switch self {
    case .invalid(let msg): return msg
    case .valid, .empty:    return nil
    }
  }
}
