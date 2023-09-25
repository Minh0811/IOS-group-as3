/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Vo Khai Minh
  ID: 3879953
  Created  date: 16/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

class PostViewModel: ObservableObject {
    // @Published var userService = UserService()
     @Published var dataLoaded: Bool = false
     @Published var posts: [Post] = []
     @Published var userPosts: [Post] = [] {
         didSet {
             if !userPosts.isEmpty {
                 dataLoaded = true
             }
         }
     }
     
     
     @Published var allUsers: [User] = [] // Store the list of users
     
     @Published var comments: [Comment] = []
    
    init() {
        fetchAllUsers()
        fetchPosts()
    }
    
    
    func fetchPosts() {
        Task {
            do {
                let fetchedPosts = try await PostService().fetchPosts()
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                }
            } catch {
                // Handle error
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUserPosts(userId: String) {
        Task {
            do {
                let fetchedPosts = try await PostService().fetchPosts()
                let fetchedUserPosts = fetchedPosts.filter { $0.userId == userId }
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                    self.userPosts = fetchedUserPosts
                }
            } catch {
                // Handle error
                print(error.localizedDescription)
            }
        }
    }
    
    
    func editPost(postId: String, newCaption: String) async {
        do {
            try await PostService().editPost(id: postId, newCaption: newCaption)
        } catch {
            
        }
    }
    
    func fetchAllUsers() {
        UserService.fetchAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self?.allUsers = users
                }
            case .failure(let error):
                // Handle the error appropriately
                print("Error fetching users:", error)
            }
        }
    }
    
    
    func likePost(postId: String, userIdArray: [String]) {
        Task {
            try? await PostService().likePost(id: postId, likeArray: userIdArray)
        }
    }
    
    func fetchComments(for postId: String) {
      
        
        Task {
            do {
                let fetchedComments = try await CommentService().fetchComments(for: postId)
                DispatchQueue.main.async {
                    self.comments = fetchedComments
                 
                }
            } catch {
               
            }
        }
    }
    
    
    func postComment(text: String, by user: User, for postId: String) {
         
            let newComment = Comment(id: UUID().uuidString, postId: postId, userId: user.id, username: user.username, text: text, timestamp: Date())
            Task {
                do {
                    print("Attempting to post comment...")
                    try await CommentService().addComment(newComment, to: postId)
                    print("Comment posted successfully!")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        // After successfully adding the comment
                        if let index = self?.posts.firstIndex(where: { $0.id == postId }) {
                            self?.posts[index].commentsCount += 1
                        }
                    }
                    
                    // Update the post's commentsCount in the Firestore database
                    try await PostService().incrementCommentsCount(for: postId)
                    
                } catch {
                    // Handle error
                    print("Error posting comment: \(error.localizedDescription)")
                }
            }
        fetchComments(for: postId)
            print("Finished posting comment for postId: \(postId)")
        }
    
    
    
    
    
    func commentCount(for postId: String) -> Int {
        return comments.filter { $0.postId == postId }.count
        
    }
}



