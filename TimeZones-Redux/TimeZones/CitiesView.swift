//
//  CitiesView.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import Combine
import SwiftUI

struct CitiesView: View {
    @EnvironmentObject var store: Store<CitiesState, CitiesAction, AppEnvironment>

    var body: some View {
        NavigationView {
            List(store.state.filteredCities) { city in
                CityView(city: city, isEditing: !store.state.searchText.isEmpty) {
                    withAnimation {
                        store.send(.toggle(id: city.id))
                    }
                }
            }
            .navigationBarTitle("TimeZones")
            .onAppear(perform: { store.send(.fetch) })
            .searchable(text: store.binding(
                get: \.searchText,
                send: CitiesAction.search
            ))
            .refreshable(action: {
                await store.send(.refresh, while: \.isLoading)
            })
        }
    }
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView().environmentObject(
            Store(
                initialState: .init(),
                  reducer: citiesReducer,
                  environment: AppEnvironment()
            )
        )
    }
}
