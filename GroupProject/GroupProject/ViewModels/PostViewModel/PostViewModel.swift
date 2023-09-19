//
//  PostViewModel.swift
//  GroupProject
//
//  Created by Minh Vo on 16/09/2023.
//

import SwiftUI

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
       
    func fetchPosts() {
        Task {
            do {
                self.posts = try await PostService().fetchPosts()
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



