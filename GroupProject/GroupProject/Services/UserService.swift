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
//
//    // Fetch the current user's data
//    func fetchCurrentUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
//        db.collection("users").document(uid).getDocument { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = snapshot?.data() else {
//                completion(.failure(NSError(domain: "No data found", code: -1, userInfo: nil)))
//                return
//            }
//
//            let uid = data["uid"] as? String ?? ""
//            let email = data["email"] as? String ?? ""
//            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
//
//            let user = User(uid: uid, email: email, profileImageUrl: profileImageUrl)
//            completion(.success(user))
//        }
//    }
//
//    // Log in a user
//    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            completion(.success(true))
//
//        }
//    }
//
//    // Create a new user account
//    func createNewAccount(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            completion(.success(true))
//        }
//    }
//
//    // Log out the current user
//    func logOut(completion: @escaping (Result<Bool, Error>) -> Void) {
//        do {
//            try Auth.auth().signOut()
//            completion(.success(true))
//        } catch let signOutError {
//            completion(.failure(signOutError))
//        }
//    }
        @Published var errorMessage = ""
        @Published var chatUser: User?
         
        init() {
            fetchCurrentUser()
        }
         
         func fetchCurrentUser() {
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
//                let fname = data["fname"] as? String ?? ""
//                let lname = data["lname"] as? String ?? ""
                 
                self.chatUser = User(uid: uid, email: email, profileImageUrl: profileImageUrl)
            }
        }
    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
                        if err != nil {
                            print("Failed to login user")
                            completion(.failure(err!))
                            //self.StatusMessage = "Failed to login user"
                            //self.shouldShowLoginAlert = true
                            return
                        }
               
                        print("Successfully logged in as user")
                            completion(.success(true))
               
                        //self.StatusMessage = "Successfully logged in as user:"
             
                        //self.isUserCurrentlyLoggedOut = true
                    }
    }
    func createNewAccount(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
                Auth.auth().createUser(withEmail: email, password: password) { result, err in
                    if err != nil {
                        print("Failed to create user")
                        completion(.failure(err!))
                        //self.StatusMessage = "Failed to create user"
                        return
                    }
    
                    print("Successfully created user")
    
                    //self.StatusMessage = "Successfully created user"
    
                    self.storeUserInformation(email: email)
                    completion(.success(true))
                }
            }
    func storeUserInformation(email: String) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userData = ["email": email, "profileImageUrl": "profileurl", "uid": uid]
            Firestore.firestore().collection("users")
                .document(uid).setData(userData) { err in
                    if let err = err {
                        print(err)
                        //self.StatusMessage = "\(err)"
                        return
                    }
    
                    print("Success store user info")
                }
        }
}
