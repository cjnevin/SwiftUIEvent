//
//  TimeZonesApp.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import SwiftUI

@main
struct TimeZonesApp: App {
    var body: some Scene {
        WindowGroup {
            CitiesView().environmentObject(CitiesService())
        }
    }
}
