//
//  ProfileUser.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

import Foundation
import SDWebImageSwiftUI
import Firebase
 
struct User {
    let uid, email, profileImageUrl: String
}
 
class ProfileUser: ObservableObject {
     
    @Published var errorMessage = ""
    @Published var chatUser: User?
     
    init() {
         
        fetchCurrentUser()
    }
     
    private func fetchCurrentUser() {
 
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
         
         
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
             
            self.errorMessage = "123"
             
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                 
            }
            self.errorMessage = "Data: \(data.description)"
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
             
            self.chatUser = User(uid: uid, email: email, profileImageUrl: profileImageUrl)
             
            //self.errorMessage = chatUser.profileImageUrl
             
        }
    }
}
