//
//  PostViewModel.swift
//  GroupProject
//
//  Created by Minh Vo on 16/09/2023.
//

import SwiftUI

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []

    @Published var userPosts: [Post] = [] {
            didSet {
                if !userPosts.isEmpty {
                    dataLoaded = true
                }
            }
        }
        @Published var dataLoaded: Bool = false
    @Published var allUsers: [User] = [] // Store the list of users
    
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
}



