//
//  SearchView.swift
//  GroupProject
//
//  Created by Bao Luong Gia on 21/09/2023.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @Binding var isSheetPresented : Bool
    @StateObject var locationManager: LocationManager = .init()
    @Binding var location : LocationItem
    var body: some View {
        VStack{
            HStack(spacing: 15){
                
                Text("Search Location")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth:.infinity ,alignment: .center)
            HStack(spacing:10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Find locations here", text: $locationManager.searchText)
                    .padding(.vertical,12)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(.gray))
            }
            if let places = locationManager.fetchedPlaces,!places.isEmpty{
                List{
                    ForEach(places,id:\.self){ place in
                        HStack(spacing: 15){
                            Image(systemName: "mappin.circle.fill").font(.title2)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(place.name ?? "")
                                    .font(.title3.bold())
                                Text(place.locality ?? "")
                                    .font(.caption).foregroundColor(.gray)
                            }
                        }.onTapGesture {
                            location = LocationItem(imageUrl: "", name: place.name!, coordinate: CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!))
                            isSheetPresented = false
                        }
                    }
                }.listStyle(.plain)
            }
        }
        .padding()
        .frame(maxHeight: .infinity,alignment: .top)
    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Text("sada")
    }
}
