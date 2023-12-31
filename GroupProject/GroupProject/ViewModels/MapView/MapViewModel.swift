//
//  MapViewModel.swift
//  mapviewtest
//
//  Created by Bao Luong Gia on 21/09/2023.
//

import MapKit

enum MapDetails{
    static let startingLocation = CLLocationCoordinate2D(latitude: 10.729250, longitude:106.695520)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var dataLoaded: Bool = false
    @Published var posts: [Post] = []
    
    var locationManager : CLLocationManager?
    @Published var region = MKCoordinateRegion(center:MapDetails.startingLocation,span: MapDetails.defaultSpan)
    func checkIfLocationServiceIsEnabled(){
            if CLLocationManager.locationServicesEnabled(){
                locationManager = CLLocationManager()
                locationManager!.delegate = self
            }else{
                print("WRONG")
            }
        }
    func fetchPosts() {
        Task {
            do {
                let fetchedPosts = try await PostService().fetchPosts()
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                }
            } catch {
                // Handle error
                print(error.localizedDescription)
            }
        }
    }
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else{ return
        }
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your Location is restricted likely due to parental controls")
        case .denied:
            print("You have denied access")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        checkLocationAuthorization()
    }
}
