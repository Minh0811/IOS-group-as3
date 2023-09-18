//
//  ProfileUser.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//
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
//    var isCurrentUser: Bool {
//        
//    }
}
extension User{
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "empty.chul", email: "check@gmail.com", profileImageUrl: "Login", fullname: "Khanh", bio: "rmit student"),
        .init(id: NSUUID().uuidString, username: "khanh1", email: "check1@gmail.com", profileImageUrl: "profile", fullname: "Tran Huy Khanh", bio: "rmit student"),
        .init(id: NSUUID().uuidString, username: "khanh2", email: "check2@gmail.com", profileImageUrl: "home", fullname: "Vo Khai Minh", bio: "rmit student"),

    ]
}


