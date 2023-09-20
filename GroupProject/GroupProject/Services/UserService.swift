//
//  UserService.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import UIKit


class UserService: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var errorMessage = ""
    @Published var currentUser: User?
    
    init() {
        fetchCurrentUser { user in
            self.currentUser = user
        }
    }

    func fetchCurrentUser(completion: @escaping (User?) -> Void) {
            guard let id = Auth.auth().currentUser?.uid else {
                self.errorMessage = "Could not find firebase uid"
                completion(nil)
                return
            }

            Firestore.firestore().collection("users").document(id).getDocument { snapshot, error in
                if let error = error {
                    print("Failed to fetch current user:", error)
                    completion(nil)
                    return
                }

                guard let data = snapshot?.data() else {
                    self.errorMessage = "No data found"
                    completion(nil)
                    return
                }

                let user = User(
                    id: id,
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    profileImageUrl: data["profileImageUrl"] as? String,
                    fullname: data["fullname"] as? String,
                    bio: data["bio"] as? String
                )
                
                completion(user)
            }
        }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user")
                completion(.failure(err))
                return
            }
            
            print("Successfully logged in as user")
            completion(.success(true))
        }
    }
    
    func createNewAccount(email: String, password: String,username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user")
                completion(.failure(err))
                return
            }
            
            print("Successfully created user")
            self.storeUserInformation(email: email, username: username)
            completion(.success(true))
        }
    }
    
    func storeUserInformation(email: String, username: String) {
        guard let id = Auth.auth().currentUser?.uid else { return }
        let data = ["email": email, "id": id,"username": username]
        Firestore.firestore().collection("users")
            .document(id).setData(data) { err in
                if let err = err {
                    print(err)
                    return
                }
                
                print("Success store user info")
            }
    }
    func updateUserProfileData(data: [String: Any]) async throws {
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        // Update user data in Firestore
        let userRef = Firestore.firestore().collection("users").document(id)
        do {
            try await userRef.updateData(data)
            print("update success")
            fetchCurrentUser { user in
                self.currentUser = user
                print("fetch success")
            }
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
            throw error
        }
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    static func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var users: [User] = []
            
            for document in snapshot!.documents {
                let data = document.data()
                
                let id = document.documentID
                let username = data["username"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String
                let fullname = data["fullname"] as? String
                let bio = data["bio"] as? String
                
                let user = User(id: id, username: username, email: email, profileImageUrl: profileImageUrl, fullname: fullname, bio: bio)
                users.append(user)
            }
            
            completion(.success(users))
        }
    }
    
    func followUser(userIdToFollow: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        // Update the following list of the current user
        let followingRef = Firestore.firestore().collection("users").document(currentUserId)
        followingRef.updateData(["following": FieldValue.arrayUnion([userIdToFollow])])
        
        // Update the followers list of the user being followed
        let followerRef = Firestore.firestore().collection("users").document(userIdToFollow)
        followerRef.updateData(["followers": FieldValue.arrayUnion([currentUserId])])
    }
    
    func unfollowUser(userIdToUnfollow: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        // Update the following list of the current user
        let followingRef = Firestore.firestore().collection("users").document(currentUserId)
        followingRef.updateData(["following": FieldValue.arrayRemove([userIdToUnfollow])])
        
        // Update the followers list of the user being unfollowed
        let followerRef = Firestore.firestore().collection("users").document(userIdToUnfollow)
        followerRef.updateData(["followers": FieldValue.arrayRemove([currentUserId])])
    }
    
    
    
    
}

