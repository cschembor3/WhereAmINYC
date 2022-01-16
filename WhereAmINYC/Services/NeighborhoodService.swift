//
//  NeighborhoodService.swift
//  WhereAmINYC
//
//  Created by Connor Schembor on 1/8/22.
//

import Foundation

class NeighborhoodService {
    
    private static let nycPostalCodeRange = 10001...11697
    
    private let geocodingApi: GeocodingApiInterface
    init(geocodingApi: GeocodingApiInterface) {
        self.geocodingApi = geocodingApi
    }
    
    func getNeighborhood(for coordinates: Coordinate) async throws -> Neighborhood {
        let neighborhood = try await self.geocodingApi.getNeighborhoodLookup(for: coordinates)
        guard let postalCode = Int(neighborhood.postalCode) else { throw MissingPostalCodeError() }
        guard NeighborhoodService.nycPostalCodeRange ~= postalCode else { throw LocationNotInNYCError() }
        return neighborhood
    }
}

protocol InvalidLocationError: Error {}
struct LocationNotInNYCError: InvalidLocationError {}
