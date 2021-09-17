//
//  Array+CopyAtKeyPath.swift
//  TimeZones
//
//  Created by Chris Nevin on 17/9/21.
//

import Foundation

extension Array {
    /// Copy particular keyPath from each item to self.
    /// Assumes self.count == items.count and items are sorted the same.
    mutating func copy<T>(_ keyPath: WritableKeyPath<Element, T>, from items: [Element]) {
        zip(indices, items).forEach { index, item in
            self[index][keyPath: keyPath] = item[keyPath: keyPath]
        }
    }
}
