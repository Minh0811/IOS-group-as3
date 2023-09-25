/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Tuan Kiet
  ID: 3879300
  Created  date: 15/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import Foundation
import CoreLocation

struct Post: Identifiable, Codable, Equatable {
    var id: String
    var userId: String  // User ID of the post creator
    var username: String  // Username of the post creator
    var imageUrl: String  // URL of the image associated with the post
    var caption: String  // Caption or status of the post
    var like: [String]
    var commentsCount: Int = 0
    var category: String
    var name: String
    var coordinates : Coordinates
    var location : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double

}
extension Post {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id // Assuming `id` uniquely identifies a Post
    }
}

struct LocationItem: Identifiable {
    let id = UUID()
    let imageUrl:String
    let name : String
    var coordinate: CLLocationCoordinate2D
}
