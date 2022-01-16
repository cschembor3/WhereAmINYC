//
//  LocationResponse.swift
//  WhereAmINYC WatchKit Extension
//
//  Created by Connor Schembor on 1/2/22.
//

import Foundation

struct LocationResponse: Codable {
    let query: [Float]
    let features: [Feature]
}

extension LocationResponse {
    func toNeighborhoodInfo() throws -> Neighborhood {
        guard let neighborhoodInfo = features[0].context.first(where: { $0.id.contains("neighborhood") }) else {
            throw MissingNeighborhoodError()
        }
        
        guard let boroughInfo = features[0].context.first(where: { $0.id.contains("locality")}) else {
            throw MissingBoroughError()
        }
        
        guard let postalCodeInfo = features[0].context.first(where: { $0.id.contains("postcode") }) else {
            throw MissingPostalCodeError()
        }

        return Neighborhood(
            neighborhood: neighborhoodInfo.text,
            borough: boroughInfo.text,
            postalCode: postalCodeInfo.text
        )
    }
}

struct Feature: Codable {
    let context: [LocationInfo]
}

struct LocationInfo: Codable {
    let id: String
    let text: String
}

protocol NeighborhoodError: Error {}
struct MissingNeighborhoodError: NeighborhoodError {}
struct MissingBoroughError: NeighborhoodError {}
struct MissingPostalCodeError: NeighborhoodError {}
