//
//  NeighborhoodViewModel.swift
//  WhereAmINYC WatchKit Extension
//
//  Created by Connor Schembor on 1/2/22.
//

import Combine
import Foundation
import SwiftUI

@MainActor class NeighborhoodViewModel: ObservableObject {
    
    @Published var neighborhoodText: String?
    @Published var boroughText: String?
    @Published var errorOccurred: Bool = false
    
    private var coordinates: Coordinate? = nil
    private var cancellables: Set<AnyCancellable> = Set()
    private let locationService: LocationService
    private let neighborhoodService: NeighborhoodService
    init(
        locationService: LocationService,
        neighborhoodService: NeighborhoodService
    ) {
        self.locationService = locationService
        self.neighborhoodService = neighborhoodService
        self.setupLocationSubscription()
    }
    
    func setupLocationSubscription() {
        self.locationService.$currLocation
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let 💪self = self else { return }
                guard let x = location?.coordinate.latitude,
                      let y = location?.coordinate.longitude else { return }
                
                Task {
                     do {
                         let neighborhood = try await 💪self.neighborhoodService.getNeighborhood(
                            for: Coordinate(x: x, y: y)
                         )
                         
                         💪self.neighborhoodText = neighborhood.neighborhood
                         💪self.boroughText = neighborhood.borough
                         💪self.errorOccurred = false
                    } catch is LocationNotInNYCError, is MissingNeighborhoodError {
                        💪self.neighborhoodText = "It looks like you're not in NYC...😞"
                        💪self.boroughText = nil
                        💪self.errorOccurred = true
                    } catch {
                        💪self.neighborhoodText = "There was an error getting your location 😬"
                        💪self.boroughText = nil
                        💪self.errorOccurred = true
                    }
                }
            }
            .store(in: &cancellables)
    }
}
