//
//  ContentView.swift
//  WhereAmINYC WatchKit Extension
//
//  Created by Connor Schembor on 1/20/22.
//

import SwiftUI

struct NeighborhoodView: View {
    
    @ObservedObject var viewModel: NeighborhoodViewModel
    @State private var isLoading: Bool = false
    
    init(viewModel: NeighborhoodViewModel) {
        self.viewModel = viewModel
        self.isLoading = viewModel.neighborhoodText.orEmpty.isEmpty
    }

    var body: some View {
        
        ZStack {

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .zIndex(1)
                .foregroundColor(.white)
                .opacity(self.isLoading ? 1 : 0)
            
            GeometryReader { geo in
                
                VStack {
                    
                    Text(viewModel.neighborhoodText.orEmpty)
                        .font(.monospaced(.title)())
                        .foregroundColor(.white)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .padding([.leading, .trailing, .top, .bottom], 5)
                    
                    if !viewModel.boroughText.orEmpty.isEmpty {
                        Text(viewModel.boroughText.orEmpty)
                            .font(.monospaced(.body)())
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                }
                .frame(
                    width: geo.size.width,
                    height: geo.size.height * 0.95,
                    alignment: .center
                )
                .background(viewModel.errorOccurred ? .red : .purple)
                .cornerRadius(20)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
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
