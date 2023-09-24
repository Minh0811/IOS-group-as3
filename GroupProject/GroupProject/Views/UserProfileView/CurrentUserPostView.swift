//
//  CurrentUserPostView.swift
//  GroupProject
//
//  Created by Minh Vo on 19/09/2023.
//

import SwiftUI
import Kingfisher

struct CurrentUserPostView: View {
    @ObservedObject var viewModel: PostViewModel
    var currentUser: User
  //  @State private var isDataLoaded: Bool = false
    @EnvironmentObject var globalSettings: GlobalSettings
    private let gridLayout = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        if viewModel.dataLoaded {
            LazyVGrid(columns: gridLayout, spacing: 2) {
                ForEach(viewModel.userPosts) { post in
                    NavigationLink(
                        destination: CommentView(viewModel: viewModel, postId: post.id, post: post).environmentObject(globalSettings),
                        label: {
                            UserPostThumbnailView(post: post)
                        })
                    .navigationBarHidden(true)
                    .foregroundColor(.black)
                }
            }

            .onAppear {
                if !viewModel.dataLoaded {
                           viewModel.fetchUserPosts(userId: currentUser.id)
                       }
            }
        } else {
            // Display a loading indicator or placeholder
            Text("Loading...")
        }
    }
}

struct UserPostThumbnailView: View {
    let post: Post
    
    var body: some View {
        AsyncImage(url: post.imageUrl)
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width/3 - 4, height: UIScreen.main.bounds.width/3 - 4) // Assuming 2 points spacing
            .clipped()
    }
}





struct CurrentUserPostView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock user for the preview
        let mockUser = User(id: "80gqEow1wJRHXHgxw7XmSAjqZ8Y2", username: "mockUser", email: "mock@example.com", followers: [], following: [])
        
        // Create a mock viewModel for the preview
        let mockViewModel = PostViewModel()
        
        // Pass the mock user and mock viewModel to the CurrentUserPostView
        CurrentUserPostView(viewModel: mockViewModel, currentUser: mockUser)
    }
}


