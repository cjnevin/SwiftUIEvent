//
//  CitiesState.swift
//  TimeZones
//
//  Created by Chris Nevin on 17/9/21.
//

import Combine

struct CitiesState {
    var allCities: [City] = []
    var filteredCities: [City] = []
    var isLoading: Bool = false
    var searchText: String = ""
}

enum CitiesAction {
    case refresh
    case fetch
    case loaded([City])
    case search(text: String)
    case toggle(id: String)
}

struct AppEnvironment {
    var cities: CitiesService = .init()
}

let citiesReducer: Reducer<CitiesState, CitiesAction, AppEnvironment> = { state, action, environment in
    print(action)

    switch action {
    case .refresh:
        state.isLoading = true
        return environment.cities.refresh()
            .map(CitiesAction.loaded)
            .eraseToAnyPublisher()

    case .fetch:
        state.isLoading = true
        return environment.cities.fetch()
            .map(CitiesAction.loaded)
            .eraseToAnyPublisher()

    case .loaded(var items):
        if !state.allCities.isEmpty {
            // Keep favourites from existing state
            items.copy(\.favourite, from: state.allCities)
        }
        state.allCities = items
        state.isLoading = false

    case .toggle(let id):
        if let index = state.allCities.firstIndex(where: { $0.id == id }) {
            state.allCities[index].favourite.toggle()
        }

    case .search(let text):
        state.searchText = text
    }

    // Reapply filter once searchText or allCities has changed
    state.filteredCities = state.allCities.search(for: state.searchText)

    return Empty().eraseToAnyPublisher()
}
