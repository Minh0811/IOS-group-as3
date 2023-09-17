//
//  UserService.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import Firebase
import FirebaseFirestore
import UIKit
import FirebaseStorage

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
                        bio: data["bio"] as? String
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
        let data = ["email": email, "id": id, "username":  username]
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
    
}

