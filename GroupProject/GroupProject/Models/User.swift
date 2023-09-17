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
    
//    init(id: String, username: String, email: String, profileImageUrl: String?, fullname: String?, bio: String?) {
//          self.id = id
//          self.username = username
//          self.email = email
//          self.profileImageUrl = profileImageUrl
//          self.fullname = fullname
//          self.bio = bio
//      }
}
extension User{
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "empty.chul", email: "check@gmail.com", profileImageUrl: "Login", fullname: "Khanh", bio: "rmit student"),
        .init(id: NSUUID().uuidString, username: "khanh1", email: "check1@gmail.com", profileImageUrl: "profile", fullname: "Tran Huy Khanh", bio: "rmit student"),
        .init(id: NSUUID().uuidString, username: "khanh2", email: "check2@gmail.com", profileImageUrl: "home", fullname: "Vo Khai Minh", bio: "rmit student"),

    ]
}

//Check for usability since the main view now use MainViewModel
//class ProfileUser: ObservableObject {
//    private var userService: UserService
//    @Published var errorMessage = ""
//    @Published var chatUser: User?
//
//    init(userService: UserService = UserService()) {
//        self.userService = userService
//        fetchCurrentUser()
//    }
//
//    private func fetchCurrentUser() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            self.errorMessage = "Could not find firebase uid"
//            return
//        }
//
//        userService.fetchCurrentUser(uid: uid) { [weak self] result in
//            switch result {
//            case .success(let user):
//                self?.chatUser = user
//            case .failure(let error):
//                self?.errorMessage = "Failed to fetch current user: \(error)"
//            }
//        }
//    }
//}
