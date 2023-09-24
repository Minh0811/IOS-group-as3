import MapKit
import SwiftUI
import Foundation

struct MapView: View {
    @StateObject private var postViewModel = PostViewModel()
    @StateObject private var viewModel = MapViewModel()
    @State private var displayDetail = false
    @State private var update = false
    @State private var mockPost = Post(id: "1", userId: "1", username: "1", imageUrl: "1", caption: "1", like: [], category: "1", name: "1", coordinates:Coordinates(latitude: 1,longitude: 1))
    var body: some View{
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.posts ){locationItem in
                MapAnnotation(coordinate: locationItem.location) {
                    VStack{
                        HStack {
                            AsyncImage(url: locationItem.imageUrl)
                                .aspectRatio(1,contentMode: .fit)
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
                            .offset(x: -12.5, y:-10)
                        NavigationLink("", destination: DetailView(post: mockPost, viewModel: postViewModel), isActive: $displayDetail)
                            .opacity(0) // Make the NavigationLink invisible
                    }.onTapGesture {
                        mockPost = locationItem
                        mockPost = locationItem
                        displayDetail = true
                        print(locationItem.caption)
                    }
                    
                }
                
            }
            .ignoresSafeArea()
            .accentColor(.pink)
            .onAppear{
                Task{
                    DispatchQueue.main.async {
                        viewModel.fetchPosts()
                        
                    }
                    
                }
            
            }
        }
    
}

struct MapView_Previews: PreviewProvider{
    static var previews: some View{
        MapView()
    }
}
