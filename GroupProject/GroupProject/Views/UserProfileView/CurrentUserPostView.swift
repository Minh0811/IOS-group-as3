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
    let scalingFactor: CGFloat
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
                        destination: CommentView(viewModel: viewModel, scalingFactor: scalingFactor, postId: post.id, post: post).environmentObject(globalSettings),
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




