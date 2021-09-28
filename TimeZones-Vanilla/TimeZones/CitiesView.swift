//
//  CitiesView.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import Combine
import SwiftUI

struct CitiesView: View {
    @EnvironmentObject var citiesService: CitiesService
    @State var allCities: [City] = []
    @State var searchText: String = ""
    @State var cancellables: Set<AnyCancellable> = []

    var body: some View {
        NavigationView {
            List(filteredCities) { city in
                CityView(city: city, isEditing: !searchText.isEmpty) {
                    withAnimation {
                        toggle(id: city.id)
                    }
                }
            }
            .navigationTitle("TimeZones")
            .searchable(text: $searchText)
            .onAppear { fetchCities() }
            .refreshable { await refreshCities() }
        }
    }

    var filteredCities: [City] {
        allCities.search(for: searchText)
    }

    func toggle(id: String) {
        if let index = allCities.firstIndex(where: { $0.id == id }) {
            allCities[index].favourite.toggle()
        }
    }

    func fetchCities() {
        citiesService.fetch().sink { newCities in
            allCities = newCities
        }.store(in: &cancellables)
    }

    func refreshCities() async {
        let newCities = await citiesService.refresh().await()
        allCities.copy(\.time, from: newCities)
    }
}

struct CitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesView()
            .environmentObject(CitiesService())
    }
}
