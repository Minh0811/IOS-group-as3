////
////  UserService.swift
////  GroupProject
////
////  Created by Minh Vo on 13/09/2023.
////
//
//import Firebase
//import FirebaseFirestore
//import UIKit
//import FirebaseStorage
//
//class UserService: ObservableObject {
//    let db = Firestore.firestore()
//        @Published var errorMessage = ""
//        //@Published var chatUser: User?
//    private var uiImage: UIImage?
//        init() {
//            fetchCurrentUser()
//        }
//
//         func fetchCurrentUser() {
//            guard let uid = Auth.auth().currentUser?.uid else {
//                self.errorMessage = "Could not find firebase uid"
//                return
//            }
//
//            Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
//                if let error = error {
//                    self.errorMessage = "Failed to fetch current user: \(error)"
//                    print("Failed to fetch current user:", error)
//                    return
//                }
//
//                self.errorMessage = "123"
//
//                guard let data = snapshot?.data() else {
//                    self.errorMessage = "No data found"
//                    return
//                }
//
//                self.errorMessage = "Data: \(data.description)"
//                _ = data["uid"] as? String ?? ""
//                _ = data["email"] as? String ?? ""
//                //let profileImageUrl = data["profileImageUrl"] as? String ?? ""
////                let fname = data["fname"] as? String ?? ""
////                let lname = data["lname"] as? String ?? ""
//
//                //self.chatUser = User(uid: uid, email: email, profileImageUrl: profileImageUrl)
//            }
//        }
//    func loginUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void){
//        Auth.auth().signIn(withEmail: email, password: password) { result, err in
//                        if err != nil {
//                            print("Failed to login user")
//                            completion(.failure(err!))
//                            //self.StatusMessage = "Failed to login user"
//                            //self.shouldShowLoginAlert = true
//                            return
//                        }
//
//                        print("Successfully logged in as user")
//                            completion(.success(true))
//
//                        //self.StatusMessage = "Successfully logged in as user:"
//
//                        //self.isUserCurrentlyLoggedOut = true
//                    }
//    }
//    func createNewAccount(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//                Auth.auth().createUser(withEmail: email, password: password) { result, err in
//                    if err != nil {
//                        print("Failed to create user")
//                        completion(.failure(err!))
//                        //self.StatusMessage = "Failed to create user"
//                        return
//                    }
//
//                    print("Successfully created user")
//
//                    //self.StatusMessage = "Successfully created user"
//
//                    self.storeUserInformation(email: email)
//                    completion(.success(true))
//                }
//            }
//    func storeUserInformation(email: String) {
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            let data = ["email": email, "uid": uid]
//            Firestore.firestore().collection("users")
//                .document(uid).setData(data) { err in
//                    if let err = err {
//                        print(err)
//                        //self.StatusMessage = "\(err)"
//                        return
//                    }
//
//                    print("Success store user info")
//                }
//        }
//    func updateUserData() async throws {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        var data = [String: Any]()
//        if let uiImage = uiImage {
//            let filename = NSUUID().uuidString
//            let imageUrl = try? await UserService.uploadImage(image: uiImage, filename: filename, userId: uid)
//            data["profileImageUrl"] = imageUrl
//            data["profileImageFilename"] = filename
//
//        }
//        let userRef = Firestore.firestore().collection("users").document(uid)
//        try await userRef.updateData(data)
//    }
//    static func uploadImage(image: UIImage, filename: String, userId: String) async throws -> String? {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
//
//        // Use the provided filename and user's UID in the storage path
//        let ref = Storage.storage().reference(withPath: "/profile_images/\(userId)/\(filename)")
//
//        do {
//            let _ = try await ref.putDataAsync(imageData)
//            let url = try await ref.downloadURL()
//            return url.absoluteString
//        } catch {
//            print("\(error.localizedDescription)")
//            return nil
//        }
//    }
//
//}
import Firebase
import FirebaseFirestore
import UIKit
import FirebaseStorage

class UserService: ObservableObject {
    let db = Firestore.firestore()
    @Published var errorMessage = ""

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

    func createNewAccount(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user")
                completion(.failure(err))
                return
            }

            print("Successfully created user")
            self.storeUserInformation(email: email)
            completion(.success(true))
        }
    }

    func storeUserInformation(email: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = ["email": email, "uid": uid]
        Firestore.firestore().collection("users")
            .document(uid).setData(data) { err in
                if let err = err {
                    print(err)
                    return
                }

                print("Success store user info")
            }
    }
    func updateUserProfileData(data: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Update user data in Firestore
        let userRef = Firestore.firestore().collection("users").document(uid)
        do {
            try await userRef.updateData(data)
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
            throw error
        }
    }


    
}


