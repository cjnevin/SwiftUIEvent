//
//  City.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import Foundation

struct City: Identifiable, Comparable {
    static func < (lhs: City, rhs: City) -> Bool {
        lhs.name < rhs.name
    }
    var id: String
    var current: Bool
    var favourite: Bool
    var gmtOffset: String
    var name: String
    var time: String
}

extension Sequence where Element == City {
    func search(for searchText: String) -> [City] {
        filter {
            searchText.isEmpty
                ? $0.favourite
                : $0.name.lowercased().starts(with: searchText.lowercased())
        }
    }
}
