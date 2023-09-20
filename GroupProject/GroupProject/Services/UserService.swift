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
        fetchCurrentUser()
    }
    func fetchCurrentUser() {
        guard let id = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }

        Firestore.firestore().collection("users").document(id).getDocument { snapshot, error in
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
            if let data = snapshot?.data() {
                            // Populate the User struct
                DispatchQueue.main.async {
                    let user = User(
                        id: id,
                        username: data["username"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        profileImageUrl: data["profileImageUrl"] as? String,
                        fullname: data["fullname"] as? String,
                        bio: data["bio"] as? String,
                        followers: data["followers"] as? [String] ?? [],
                        following: data["following"] as? [String] ?? []
                        
                    )
                    
                    // Assign the user object to currentUser
                    self.currentUser = user
                }
                        } else {
                            self.errorMessage = "Incomplete or incorrect data found in Firestore"
                        }
            self.errorMessage = "Data: \(data.description)"
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
            self.fetchCurrentUser()
            print("fetch success")
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
                    let followers = data["followers"] as? [String] ?? []
                    let following = data["following"] as? [String] ?? []


                    let user = User(id: id, username: username, email: email, profileImageUrl: profileImageUrl, fullname: fullname, bio: bio, followers: followers, following: following)
                    users.append(user)
                }

                completion(.success(users))
            }
        }


    
    func followUser(userIDToFollow: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // Handle the case where the current user is not authenticated
            return
        }

        // Add the user ID to the following list of the current user
        db.collection("users").document(currentUserID).updateData(["following": FieldValue.arrayUnion([userIDToFollow])])

        // Add the current user's ID to the followers list of the user being followed
        db.collection("users").document(userIDToFollow).updateData(["followers": FieldValue.arrayUnion([currentUserID])])
    }

    func unfollowUser(userIDToUnfollow: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // Handle the case where the current user is not authenticated
            return
        }

        // Remove the user ID from the following list of the current user
        db.collection("users").document(currentUserID).updateData(["following": FieldValue.arrayRemove([userIDToUnfollow])])

        // Remove the current user's ID from the followers list of the user being unfollowed
        db.collection("users").document(userIDToUnfollow).updateData(["followers": FieldValue.arrayRemove([currentUserID])])
    }




    
}

