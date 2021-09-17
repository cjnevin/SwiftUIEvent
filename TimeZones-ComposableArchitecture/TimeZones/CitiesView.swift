//
//  CitiesView.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import ComposableArchitecture
import SwiftUI

struct CitiesView: View {
    let store: Store<CitiesState, CitiesAction>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List(viewStore.state.filteredCities) { city in
                    CityView(city: city, isEditing: !viewStore.state.searchText.isEmpty) {
                        viewStore.send(.toggle(id: city.id), animation: .default)
                    }
                }
                .navigationBarTitle("TimeZones")
                .onAppear(perform: { viewStore.send(.fetch) })
                .searchable(text: viewStore.binding(
                    get: \.searchText,
                    send: CitiesAction.search
                ))
                .refreshable(action: {
                    await viewStore.send(.refresh, while: \.isLoading)
                })
            }
        }
    }
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView(
            store: .init(
                initialState: CitiesState(),
                reducer: citiesReducer,
                environment: AppEnvironment()
            )
        )
    }
}
