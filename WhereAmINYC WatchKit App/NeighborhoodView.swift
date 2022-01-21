//
//  ContentView.swift
//  WhereAmINYC WatchKit Extension
//
//  Created by Connor Schembor on 1/20/22.
//

import SwiftUI

struct NeighborhoodView: View {
    
    @ObservedObject var viewModel: NeighborhoodViewModel
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Rectangle()
                    .fill(viewModel.errorOccurred ? .red : .purple)
                    .frame(width: 180, height: 100, alignment: .center)
                    .cornerRadius(10)
                
                VStack {
                    
                    Text(viewModel.neighborhoodText.orEmpty)
                        .font(.monospaced(.headline)())
                        .foregroundColor(.white)
                        .padding()
                    
                    Text(viewModel.boroughText.orEmpty)
                        .font(.monospaced(.body)())
                        .foregroundColor(.white)
                }
            }
        }
    }
}

extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? ""
    }
}

struct NeighborhoodView_Previews: PreviewProvider {
    static var previews: some View {
        NeighborhoodView(
            viewModel: NeighborhoodViewModel(
                locationService: LocationService(),
                neighborhoodService: NeighborhoodService(geocodingApi: GeocodingApi())
            )
        )
    }
}
