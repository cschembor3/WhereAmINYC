//
//  ContentView.swift
//  WhereAmINYC WatchKit Extension
//
//  Created by Connor Schembor on 1/8/22.
//

import SwiftUI

struct NeighborhoodView: View {
    
    @ObservedObject var viewModel: NeighborhoodViewModel
    
    var body: some View {
        
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .zIndex(1)
                .foregroundColor(.white)
                .opacity(viewModel.isLoading ? 1 : 0)
            
            GeometryReader { geo in
                
                VStack {
                    
                    if viewModel.errorOccurred {
                        
                        Text(viewModel.errorText.orEmpty)
                            .font(.monospaced(.body)())
                            .foregroundColor(.white)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                    } else {
                        
                        Text(viewModel.neighborhoodText.orEmpty)
                            .font(.monospaced(.title)())
                            .foregroundColor(.white)
                            .padding()
                        
                        Text(viewModel.boroughText.orEmpty)
                            .font(.monospaced(.body)())
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .frame(
                    width: geo.size.width * 0.8,
                    height: 300,
                    alignment: .center
                )
                .background(viewModel.errorOccurred ? .red : .purple)
                .cornerRadius(20)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await viewModel.reset() }
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
            .previewInterfaceOrientation(.portrait)
    }
}
