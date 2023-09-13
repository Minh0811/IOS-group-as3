//
//  UserService.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import Firebase
import FirebaseFirestore

class UserService {
    let db = Firestore.firestore()

    // Fetch the current user's data
    func fetchCurrentUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "No data found", code: -1, userInfo: nil)))
                return
            }

            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""

            let user = User(uid: uid, email: email, profileImageUrl: profileImageUrl)
            completion(.success(user))
        }
    }

    // Log in a user
    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }

    // Create a new user account
    func createNewAccount(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }

    // Log out the current user
    func logOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let signOutError {
            completion(.failure(signOutError))
        }
    }
}
