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
}



