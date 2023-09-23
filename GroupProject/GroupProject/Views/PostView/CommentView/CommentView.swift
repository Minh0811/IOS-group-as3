//
//  CommentView.swift
//  GroupProject
//
//  Created by Minh Vo on 20/09/2023.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel: PostViewModel
    let postId: String
    var post: Post
    @State private var commentText: String = ""
    @State var currentUser: User?
    var body: some View {
        
        List {
            AsyncImage(url: post.imageUrl)
                .aspectRatio(1,contentMode: .fit)
                .edgesIgnoringSafeArea(.top)
            
            DescriptionView(post: post)
            
            ZStack {
                HStack {
                    CircularProfileImageView(user: currentUser ?? User(id: "N/A", username: "N/A", email: "N/A", followers: [], following: []), size: .small )
                    TextField("Add a comment...", text: $commentText, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        if currentUser == nil || commentText == "" {
                            
                        }
                        else {
                            if let currentUser = currentUser {
                                print("Current user is authenticated with ID: \(currentUser.id)")
                                viewModel.postComment(text: commentText, by: currentUser, for: postId)
                                commentText = ""  // Clear the input field after posting
                            } else {
                                print("User is not authenticated.")
                            }
                        }
                    }
                    
                }
            }
            
            ForEach(viewModel.comments) { comment in
                VStack(alignment: .leading) {
                    //Text("Comments")
                    HStack {
                        ForEach(viewModel.allUsers) { user in
                            if user.id == comment.userId {
                                CircularProfileImageView(user: user, size: .small )
                            }
                        }
                        Text(comment.username).bold()
                    }
                    //                    Text(comment.username).bold()
                    Text(comment.text)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.fetchComments(for: postId)
                
            }
            UserService().fetchCurrentUser { user in
                self.currentUser = user
            }
        }
    }
}



struct CommentView_Previews: PreviewProvider {
    static var mockViewModel = PostViewModel()  // Create a mock view model
    static var mockPostId = "123456"  // Provide a mock post ID
    let mockPost = Post(
        id: "1234567890",
        userId: "user001",
        username: "JohnDoe",
        imageUrl: "https://example.com/path/to/image.jpg",
        caption: "Enjoying a beautiful sunset at the beach!",
        like: ["user002", "user003", "user004"],
        commentsCount: 5,
        category: "Nature",
        name: "Sunset Beach",
        coordinates: Coordinates(latitude: 34.0522, longitude: -118.2437)
    )
    
    static var previews: some View {
        CommentView(viewModel: mockViewModel, postId: mockPostId, post: Post( id: "1234567890",
                                                                              userId: "user001",
                                                                              username: "JohnDoe",
                                                                              imageUrl: "https://example.com/path/to/image.jpg",
                                                                              caption: "Enjoying a beautiful sunset at the beach!",
                                                                              like: ["user002", "user003", "user004"],
                                                                              commentsCount: 5,
                                                                              category: "Nature",
                                                                              name: "Sunset Beach",
                                                                              coordinates: Coordinates(latitude: 34.0522, longitude: -118.2437)))
    }
}

