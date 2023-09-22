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
                
                completion(user)
            }
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
                let followers = data["followers"] as? [String] ?? []
                let following = data["following"] as? [String] ?? []
                
                
                let user = User(id: id, username: username, email: email, profileImageUrl: profileImageUrl, fullname: fullname, bio: bio, followers: followers, following: following)
                users.append(user)
            }
            
            completion(.success(users))
            
        }
    }
    
    func fetchUsers() async throws -> [User] {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("users").getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    continuation.resume(throwing: NSError(domain: "Firestore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch users"]))
                    return
                }
                
                let users = documents.compactMap { document -> User? in
                    let data = document.data()
                    let id = document.documentID
                    let username = data["username"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let profileImageUrl = data["profileImageUrl"] as? String
                    let fullname = data["fullname"] as? String
                    let bio = data["bio"] as? String
                    let followers = data["followers"] as? [String] ?? []
                    let following = data["following"] as? [String] ?? []
                    
                    return User(id: id, username: username, email: email, profileImageUrl: profileImageUrl, fullname: fullname, bio: bio, followers: followers, following: following)
                }
                
                continuation.resume(returning: users)
            }
        }
    }
    
    func followUser(userId: String, currentUserId: String, followerArray: [String], followingArray: [String]) {
        guard ((Auth.auth().currentUser?.uid) != nil) else {
            return
        }
        db.collection("users").document(userId).setData(["followers": followerArray], merge: true)
        db.collection("users").document(currentUserId).setData(["following": followingArray], merge: true)
    }
    
//    func fetchAUser() async throws -> User {
//        guard let id = Auth.auth().currentUser?.uid else {
//            return User(id: "N/A", username: "N/A", email: "N/A", followers: [], following: [])
//        }
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            db.collection("posts")
//              .whereField("userId", isEqualTo: id)
//              .order(by: "timestamp", descending: true)
//              .getDocuments { snapshot, error in
//
//                  if let error = error {
//                      continuation.resume(throwing: error)
//                      return
//                  }
//                
//
//                guard let documents = snapshot?.documents else {
//                    continuation.resume(throwing: NSError(domain: "Firestore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user"]))
//                    return
//                }
//
//                let user = documents.compactMap { document -> User? in
//                    let data = document.data()
//                    let id = document.documentID
//                    let username = data["username"] as? String ?? ""
//                    let email = data["email"] as? String ?? ""
//                    let profileImageUrl = data["profileImageUrl"] as? String
//                    let fullname = data["fullname"] as? String
//                    let bio = data["bio"] as? String
//                    let followers = data["followers"] as? [String] ?? []
//                    let following = data["following"] as? [String] ?? []
//
//                    return User(id: id, username: username, email: email, profileImageUrl: profileImageUrl, fullname: fullname, bio: bio, followers: followers, following: following)
//                }
//                  self.currentUser = user[0]
//                  continuation.resume(returning: user[0])
//            }
//        }
//    }
}
