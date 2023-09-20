//
//  PostViewModel.swift
//  GroupProject
//
//  Created by Minh Vo on 16/09/2023.
//

import SwiftUI

class PostViewModel: ObservableObject {
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
    
    
    func fetchComments(for postId: String) {
        Task {
            do {
                let fetchedComments = try await CommentService().fetchComments(for: postId)
                DispatchQueue.main.async {
                    self.comments = fetchedComments
                    print("Fetched \(fetchedComments.count) comments.")
                }
            } catch {
                // Handle error
                print(error.localizedDescription)
                print("Error fetching comments for postId: \(postId). Error: \(error.localizedDescription)")
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
                
                // After successfully adding the comment
                if let index = posts.firstIndex(where: { $0.id == postId }) {
                    posts[index].commentsCount += 1
                    // TODO: Update the post's commentsCount in the Firestore database as well
                }
                // Update the post's commentsCount in the Firestore database
                           try await PostService().incrementCommentsCount(for: postId)
                
                fetchComments(for: postId)  // Refresh comments after posting
            } catch {
                // Handle error
                print("Error posting comment: \(error.localizedDescription)")
            }
        }
        fetchComments(for: postId)
    }

    
    func commentCount(for postId: String) -> Int {
        return comments.filter { $0.postId == postId }.count
    }
}



