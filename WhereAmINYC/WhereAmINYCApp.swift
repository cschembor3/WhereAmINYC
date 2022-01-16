//
//  WhereAmINYCApp.swift
//  WhereAmINYC
//
//  Created by Connor Schembor on 1/8/22.
//

import SwiftUI

@main
struct WhereAmINYCApp: App {
    var body: some Scene {
        WindowGroup {
            NeighborhoodView(
                viewModel: NeighborhoodViewModel(
                    locationService: LocationService(),
                    neighborhoodService: NeighborhoodService(geocodingApi: GeocodingApi())
                )
            )
        }
    }
}
