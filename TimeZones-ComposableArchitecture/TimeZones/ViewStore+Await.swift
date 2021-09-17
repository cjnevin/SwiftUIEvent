//
//  Store+Async.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import ComposableArchitecture

extension ViewStore {
    //
    // Function signature taken from:
    // https://www.pointfree.co/episodes/ep154-async-refreshable-composable-architecture
    //
    // Not part of standard library yet
    //
    func send(_ action: Action, `while` isInFlight: @escaping (State) -> Bool) async {
        send(action)
        await publisher.await(while: isInFlight)
    }
}
