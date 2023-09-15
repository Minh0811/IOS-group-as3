//
//  ProfileUser.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

import Foundation
import SDWebImageSwiftUI
import Firebase

struct User: Identifiable, Codable {
    var id: String
    let uid: String
    let username: String
    let email: String
    let profileImageUrl: String?
    let fullname: String?
    let bio: String?
}
extension User{
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, uid: "", username: "kiet", email: "", profileImageUrl: "", fullname: "", bio: "")
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
