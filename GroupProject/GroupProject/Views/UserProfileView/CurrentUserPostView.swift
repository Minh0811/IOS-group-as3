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
    
    var body: some View {
        if viewModel.dataLoaded {
            VStack {
                Text("\(currentUser.id)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text("\(currentUser.username)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text("\(currentUser.fullname ?? "N/A")")
                    .font(.footnote)
                    .fontWeight(.semibold)
                VStack(spacing: 20) {
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
                Spacer()
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


struct UserPostView: View {
    let post: Post
    
    var body: some View {
        VStack {
 
            AsyncImage(url: post.imageUrl)
                .frame(width: 320, height: 320)
                .cornerRadius(20.0)
            
            HStack(spacing: 2) {
                Text(post.userId)
                    .font(.title3)
                    .fontWeight(.bold)
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
        // Create a mock user for the preview
        let mockUser = User(id: "80gqEow1wJRHXHgxw7XmSAjqZ8Y2", username: "mockUser", email: "mock@example.com")
        
        // Create a mock viewModel for the preview
        let mockViewModel = PostViewModel()
        
        // Pass the mock user and mock viewModel to the CurrentUserPostView
        CurrentUserPostView(viewModel: mockViewModel, currentUser: mockUser)
    }
}


