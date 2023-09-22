import MapKit
import SwiftUI
import Foundation

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var displayPostSheet = false
    
    var body: some View{
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.photoLocations ){locationItem in
            MapAnnotation(coordinate: locationItem.coordinate) {
                VStack{
                    HStack {
                        Image(locationItem.imageUrl)
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        ZStack {
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 15, height: 15)
                            Text("1")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }.offset(x: -17, y: 20)
                    }
                Image(systemName: "triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 10,height: 10)
                        .rotationEffect(Angle(degrees: 180))
                        .offset(x: -11.5, y:-10)
                }
            }
            
        }
            .ignoresSafeArea()
            .accentColor(.pink)
            .onAppear{
                Task{
                    viewModel.fetchPosts()
                }
                viewModel.checkIfLocationServiceIsEnabled()
            }
    }
    
}

struct MapView_Previews: PreviewProvider{
    static var previews: some View{
        MapView()
    }
}
