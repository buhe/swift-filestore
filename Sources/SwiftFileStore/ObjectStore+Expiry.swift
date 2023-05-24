//
//  File.swift
//
//
//  Created by Jun Yan on 5/18/23.
//

import Foundation

public protocol ExpirableData: DataRepresentable {
  func isExpired(at: Date) -> Bool
}

public extension ObjectStore {
  func readExpirable<T>(key: String, namespace: String, objectType: T.Type) async throws -> T? where T: ExpirableData {
    guard let object = try await read(key: key, namespace: namespace, objectType: objectType) else {
      return nil
    }
    if object.isExpired(at: Date()) {
      try await remove(key: key, namespace: namespace)
      return nil
    } else {
      return object
    }
  }
}
