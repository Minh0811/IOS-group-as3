/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Vo Khai Minh
  ID: 3879953
  Created  date: 20/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/
import SwiftUI
import Firebase

class CommentService {
    
    let db = Firestore.firestore()
    
    // Fetch comments for a specific post
    func fetchComments(for postId: String) async throws -> [Comment] {
        return try await withCheckedThrowingContinuation { continuation in
            db.collection("comments")
              .whereField("postId", isEqualTo: postId)
              .order(by: "timestamp", descending: true)
              .getDocuments { snapshot, error in

                if let error = error {
                    print("Error fetching comments from Firestore for postId: \(postId). Error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found for comments in Firestore for postId: \(postId)")
                    continuation.resume(throwing: NSError(domain: "Firestore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch comments"]))
                    return
                }

                let comments = documents.compactMap { document -> Comment? in
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let postId = data["postId"] as? String ?? ""
                    let userId = data["userId"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()

                    return Comment(id: id, postId: postId, userId: userId, username: username, text: text, timestamp: timestamp)
                }
                  
                  print("Fetched \(comments.count) comments from Firestore for postId: \(postId)")
                continuation.resume(returning: comments)
            }
        }
    }
    
    // Add a comment to a specific post
    func addComment(_ comment: Comment, to postId: String) async throws {
        let commentData: [String: Any] = [
            "id": comment.id,
            "postId": postId,
            "userId": comment.userId,
            "username": comment.username,
            "text": comment.text,
            "timestamp": Timestamp(date: comment.timestamp)
        ]
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            print("Attempting to add comment to Firestore...")
            db.collection("comments").addDocument(data: commentData) { error in
                if let error = error {
                    print("Error adding comment to Firestore: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else {
                    print("Comment added to Firestore successfully!")
                    continuation.resume(returning: ())
                }
            }
        }
    }

}

