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
    var followersCount: Int?
    var followingCount: Int?
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false}
        return currentUid == id
    }
}
extension User{
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "empty.chul", email: "check@gmail.com", profileImageUrl: "Login", fullname: "Khanh", bio: "rmit student", followersCount: 0, followingCount: 0),
        .init(id: NSUUID().uuidString, username: "khanh1", email: "check1@gmail.com", profileImageUrl: "profile", fullname: "Tran Huy Khanh", bio: "rmit student", followersCount: 0, followingCount: 0),
        .init(id: NSUUID().uuidString, username: "khanh2", email: "check2@gmail.com", profileImageUrl: "home", fullname: "Vo Khai Minh", bio: "rmit student", followersCount: 0, followingCount: 0),

    ]
}


