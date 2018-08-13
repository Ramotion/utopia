//
//  StringValidators.swift
//  Vendefy
//
//  Created by Dmitriy Kalachev on 4/17/18.
//  Copyright © 2018 Ramotion. All rights reserved.
//

import Foundation


public extension Validator where Value == String {
  static func pattern(_ pattern: String, errorMessage: String) -> Validator<String> {
    return .block(message: errorMessage) {
      $0.trimmed.matches(regex: pattern)
    }
  }

  static func empty() -> Validator<String> {
    return .block() { $0.isEmpty }
  }
}

public extension String {
  var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  func matches(regex pattern: String) -> Bool {
    return range(of: pattern, options: .regularExpression) == startIndex..<endIndex
  }
}
