//
//  GeocodingApi.swift
//  WhereAmINYC WatchKit Extension
//
//  Created by Connor Schembor on 1/2/22.
//

import Foundation

protocol GeocodingApiInterface {
    func getNeighborhoodLookup(for coordinates: Coordinate) async throws -> Neighborhood
}

class GeocodingApi: GeocodingApiInterface {

    func getNeighborhoodLookup(for coordinates: Coordinate) async throws -> Neighborhood {
        guard let url = URL(string: constructQuery(coordinates: coordinates)) else {
            throw InvalidUrlError()
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let reverseGeocodeLookup = try JSONDecoder().decode(LocationResponse.self, from: data)
        return try reverseGeocodeLookup.toNeighborhoodInfo()
    }
    
    private func constructQuery(coordinates: Coordinate) -> String {
        return """
            \(NetworkConstants.geocodingBaseUrl)\(coordinates.y),\(coordinates.x).json?limit=1&access_token=\(NetworkConstants.geocodingApiKey)
        """.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    struct InvalidUrlError: Error {}
}
