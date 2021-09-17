//
//  Store.swift
//  TimeZones
//
//  Created by Chris Nevin on 17/9/21.
//

import Combine
import SwiftUI

/// Takes an Action and the current State and returns a new State and one or more Effects.
typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> Effect<Action>

/// Effects (or side effects) are things that call external dependencies like Timers, Networking, etc
/// Effects are mapped back to Actions to be sent back to the Reducer to update the State.
typealias Effect<Action> = AnyPublisher<Action, Never>

/// The Store holds onto the latest State and allows us to send actions to the Reducer.
final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: Reducer<State, Action, Environment>
    private let environment: Environment
    private var cancellables: [AnyCancellable] = []

    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        _state = .init(initialValue: initialState)
        self.reducer = reducer
        self.environment = environment
    }

    /// Send an `Action` to update the stored `State`.
    func send(_ action: Action) {
        reducer(&state, action, environment).sink { [weak self] action in
            self?.send(action)
        }.store(in: &cancellables)
    }

    /// Send an `Action` and wait for a condition on `State` to return `false`.
    func send(_ action: Action, `while` isInFlight: @escaping (State) -> Bool) async {
        send(action)
        await $state.await(while: isInFlight)
    }
}

extension Store {
    func binding<T: Equatable>(get: KeyPath<State, T>, send: @escaping (T) -> (Action)) -> Binding<T> {
        .init(
            get: { self.state[keyPath: get] },
            set: { value in
                if self.state[keyPath: get] != value {
                    self.send(send(value))
                }
            }
        )
    }
}

