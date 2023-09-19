//
//  CurrentUserPostView.swift
//  GroupProject
//
//  Created by Minh Vo on 19/09/2023.
//

import SwiftUI
import Kingfisher

struct CurrentUserPostView: View {
    @ObservedObject var viewModel = PostViewModel()
    @ObservedObject var userService = UserService()
    @State var currentuser: User?
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.userPosts) { post in
                NavigationLink(
                    destination: DetailView(),
                    label: {
                        UserPostView(post: post)
                    })
                .navigationBarHidden(true)
                .foregroundColor(.black)
            }
        }
        .onAppear {
            userService.fetchCurrentUser()
            if let userId = userService.currentUser?.id {
                viewModel.fetchUserPosts(userId: userId)
            }
        }
    }
}
struct UserPostView: View {
    let post: Post
    
    var body: some View {
        VStack {
            AsyncImage(url: post.imageUrl)
                .frame(width: 320, height: 200)
                .cornerRadius(20.0)
            
            HStack(spacing: 2) {
                Text(post.username)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(post.caption)
                    .font(.title3)
                    .fontWeight(.light)
                NavigationLink(destination: PostEditView(viewModel: PostViewModel(), post: post)) {
                    Text("Edit")
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20.0)
    }
}



struct CurrentUserPostView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserPostView()
    }
}
