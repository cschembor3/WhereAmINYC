//
//  WhereAmINYCApp.swift
//  WhereAmINYC
//
//  Created by Connor Schembor on 1/8/22.
//

import SwiftUI

@main
class WhereAmINYCApp: App {
    
    private var viewModel: NeighborhoodViewModel
    
    required init() {
        self.viewModel = NeighborhoodViewModel(
            locationService: LocationService(),
            neighborhoodService: NeighborhoodService(geocodingApi: GeocodingApi())
        )
        
        Task { await self.viewModel.reset() }
    }
    
    var body: some Scene {
        WindowGroup {
            NeighborhoodView(
                viewModel: self.viewModel
            )
        }
    }
}
