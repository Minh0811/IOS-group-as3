//
//  PostService.swift
//  GroupProject
//
//  Created by Minh Vo on 18/09/2023.
//

import SwiftUI

import Firebase
import FirebaseStorage

class PostService: ObservableObject {
    let db = Firestore.firestore()
    
    // Function to create a new post
    func createPost(image: UIImage, caption: String) async throws -> Bool {
        do {
            // Await the result of the uploadImage function
            let imageUrl = try await ImageUploader.uploadImage(image: image)
            
            // Safely unwrap the imageUrl
            guard let unwrappedImageUrl = imageUrl else {
                throw NSError(domain: "ImageUpload", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image"])
            }
            
            // Once the image is uploaded, create the post in Firestore
            guard let userId = Auth.auth().currentUser?.uid else {
                throw NSError(domain: "Auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
            }
            
            // Fetch the username of the current user
            let userDocument = try await db.collection("users").document(userId).getDocument()
            guard let userData = userDocument.data(), let username = userData["username"] as? String else {
                throw NSError(domain: "Firestore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch username"])
            }
            
            let postData: [String: Any] = [
                "userId": userId,
                "username": username,  // Add this line
                "imageUrl": unwrappedImageUrl,
                "caption": caption,
                "timestamp": Timestamp(date: Date())
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                self.db.collection("posts").addDocument(data: postData) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: true)
                    }
                }
            }
        } catch {
            throw error
        }
    }


    
    // Function to fetch posts
    func fetchPosts() async throws -> [Post] {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("posts").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    continuation.resume(throwing: NSError(domain: "Firestore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch posts"]))
                    return
                }
                
                let posts = documents.compactMap { document -> Post? in
                    let data = document.data()
                    let id = document.documentID
                    let userId = data["userId"] as? String ?? ""
                    let imageUrl = data["imageUrl"] as? String ?? ""
                    let caption = data["caption"] as? String ?? ""
                    let username = data["username"] as? String ?? ""  // Extracting the username
                    
                    return Post(id: id, userId: userId, username: username, imageUrl: imageUrl, caption: caption)
                }
                
                continuation.resume(returning: posts)
            }
        }
    }
    
    func editPost(id: String, newCaption: String) async throws {
        do {
            guard let userId = Auth.auth().currentUser?.uid else {
                throw NSError(domain: "Auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
            }
            try await db.collection("posts").document(id).setData(["caption": "\(newCaption)"], merge: true) 
        } catch {
            throw error
        }
    }

}
