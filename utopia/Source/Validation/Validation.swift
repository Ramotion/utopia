//
//  Validation.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/17/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import Foundation

public protocol ValidatorProtocol {
  associatedtype Value
  func validate(_ value: Value) -> ValidationResult
}

public extension ValidatorProtocol {
  func asValidator() -> Validator<Value> {
    return Validator(self)
  }
}

public struct Validator<Value>: ValidatorProtocol {
  private let baseValidate: (Value) -> ValidationResult

  public init<V: ValidatorProtocol>(_ base: V) where V.Value == Value {
    baseValidate = base.validate
  }

  public static func block<T>(validator: @escaping (T) -> ValidationResult) -> Validator<T> {
    return Validator<T>(block: validator)
  }

  public static func block<T>(message: String, block: @escaping (T) -> Bool) -> Validator<T> {
    return Validator<T>(block: {
      if block($0) { return .valid }
      return .invalid(message)
    })
  }

  public static func block<T>(bool: @escaping (T) -> Bool) -> Validator<T> {
    return Validator<T>(block: {
      if bool($0) { return .valid }
      return .invalid("invalid")
    })
  }

  init(block: @escaping (Value) -> ValidationResult) {
    baseValidate = block
  }

  public func validate(_ value: Value) -> ValidationResult {
    return baseValidate(value)
  }
}

public enum ValidationResult {

  case valid
  case invalid(String)

  public var isValid: Bool {
    switch self {
    case .valid:    return true
    case .invalid:  return false
    }
  }

  public var error: String? {
    switch self {
    case .valid:              return nil
    case .invalid(let error): return error
    }
  }

  public static func && (left: ValidationResult, right: ValidationResult) -> ValidationResult {
    if left.isValid && right.isValid {
      return .valid
    }

    return .invalid(left.error ?? right.error!)
  }

  public static func || (left: ValidationResult, right: ValidationResult) -> ValidationResult {
    if left.isValid || right.isValid {
      return .valid
    }

    return .invalid(left.error ?? right.error!)
  }

}


// MARK: - Validators Composition

public enum CompoundValidator<Value>: ValidatorProtocol {
  case and(Validator<Value>, Validator<Value>)
  case or(Validator<Value>, Validator<Value>)

  public func validate(_ value: Value) -> ValidationResult {
    switch self {
    case let .and(left, right):
      return left.validate(value) && right.validate(value)

    case let .or(left, right):
      return left.validate(value) || right.validate(value)
    }
  }

}

public func && <V1: ValidatorProtocol, V2: ValidatorProtocol>(left: V1, right: V2) -> CompoundValidator<V1.Value>
  where V1.Value == V2.Value
{
  return .and(Validator(left), Validator(right))
}

public func || <V1: ValidatorProtocol, V2: ValidatorProtocol>(left: V1, right: V2) -> CompoundValidator<V1.Value>
  where V1.Value == V2.Value
{
  return .or(Validator(left), Validator(right))
}

public func && <T>(left: Validator<T>, right: Validator<T>) -> Validator<T>
{
  return CompoundValidator.and(left, right).asValidator()
}

public func || <T>(left: Validator<T>, right: Validator<T>) -> Validator<T>
{
  return CompoundValidator.or(left, right).asValidator()
}
