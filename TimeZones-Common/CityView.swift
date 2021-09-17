//
//  CityView.swift
//  TimeZones
//
//  Created by Chris Nevin on 17/9/21.
//

import SwiftUI

struct CityView: View {
    let city: City
    let isEditing: Bool
    let action: () -> Void

    var body: some View {
        if isEditing {
            Button(action: action) { content }
                .buttonStyle(.plain)
        } else {
            content
                .swipeActions {
                    Button(action: action) {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
        }
    }

    private var content: some View {
        HStack {
            if isEditing {
                Image(systemName: city.favourite ? "checkmark.square" : "square")
            }
            if city.current {
                Text(city.name)
                    .italic()
                    .bold()
            } else {
                Text(city.name)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(city.time)
                    .font(.title)
                Text("(\(city.gmtOffset))")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CityView(city: .brisbane, isEditing: true, action: {})
            CityView(city: .london, isEditing: false, action: {})
        }
    }
}

extension City {
    static let brisbane = TimeZone(identifier: "Australia/Brisbane")!.asCity()
    static let london = TimeZone(identifier: "Europe/London")!.asCity()
}
