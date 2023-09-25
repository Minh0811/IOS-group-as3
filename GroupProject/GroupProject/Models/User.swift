/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 11/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import Foundation
import SDWebImageSwiftUI
import Firebase

struct User: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    let email: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    var followers:[String]
    var following: [String]
    
}
extension User{
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "empty.chul", email: "check@gmail.com", profileImageUrl: "Login", fullname: "Khanh", bio: "rmit student", followers: [], following: []),
        .init(id: NSUUID().uuidString, username: "khanh1", email: "check1@gmail.com", profileImageUrl: "profile", fullname: "Tran Huy Khanh", bio: "rmit student", followers: [], following: []),
        .init(id: NSUUID().uuidString, username: "khanh2", email: "check2@gmail.com", profileImageUrl: "home", fullname: "Vo Khai Minh", bio: "rmit student", followers: [], following: []),

    ]
}


