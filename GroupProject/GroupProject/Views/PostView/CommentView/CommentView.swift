//
//  CommentView.swift
//  GroupProject
//
//  Created by Minh Vo on 20/09/2023.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel: PostViewModel
    @Environment(\.presentationMode) private var presentationMode:
    Binding<PresentationMode>
    @EnvironmentObject var globalSettings: GlobalSettings
    let postId: String
    var post: Post
    @State private var commentText: String = ""
    @State var currentUser: User?
    
    
    var body: some View {
        ZStack {
            globalSettings.isDark ? Color("DarkBackground") .ignoresSafeArea() :  Color("LightBackground").ignoresSafeArea()
            ScrollView {
                AsyncImage(url: post.imageUrl)
                    .aspectRatio(1, contentMode: .fit)
                    .edgesIgnoringSafeArea(.top)
                
                DescriptionView(post: post)
                    .padding(.horizontal)
                
                ZStack {
                    HStack {
                        CircularProfileImageView(user: currentUser ?? User(id: "N/A", username: "N/A", email: "N/A", followers: [], following: []), size: .small )
                            .padding(.leading)
                        
                        TextField("Add a comment...", text: $commentText, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        ZStack {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(globalSettings.isDark ? Color("DarkBackground") : Color.white)
                        }
                        .frame(width: 40, height: 40)
                        .background(globalSettings.isDark ? Color("DarkBackground") : Color("Color 2"))
                        .cornerRadius(20)
                        //.shadow(radius: 5)
                        .padding(.trailing)
                        .onTapGesture {
                            if currentUser == nil || commentText == "" {
                                // Handle empty comment or unauthenticated user
                            } else {
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
                    .frame(height: 75)
                    .background(globalSettings.isDark ? Color("DarkBackground") : Color("Color"))
                }
                .padding(.vertical, 10)
                
                ForEach(viewModel.comments) { comment in
                    HStack() {
                        VStack{
                            HStack(alignment: .top) {
                                ForEach(viewModel.allUsers) { user in
                                    if user.id == comment.userId {
                                        CircularProfileImageView(user: user, size: .small)
                                            .padding(.trailing, 5)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(comment.username).bold()
                                    Text(comment.text)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                }
                .frame(width: 350, height: 75)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(globalSettings.isDark ? Color("LightPost") :  Color("DarkPost"), lineWidth: 1)
                )
                
                
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.fetchComments(for: postId)
                }
                UserService().fetchCurrentUser { user in
                    self.currentUser = user
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarBackButtonHidden(true)
            .customBackButton(presentationMode: presentationMode)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarBackground(.hidden, for: .tabBar)
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

struct DescriptionView: View {
    var post: Post
    
    var body: some View {
        VStack (alignment: .leading) {
            //Title
            Text(post.username)
                .font(.title)
                .fontWeight(.bold)
            HStack (spacing: 4) {
                Text(post.caption)
                    .font(.title3)
                    .fontWeight(.light)
                    .padding(.trailing)
                Spacer()
            }
        }
        .padding()
        .opacity(0.8)
        .cornerRadius(15)
        //.cornerRadius(30, corners: [.topLeft, .topRight])
        //.offset(x: 0, y: -30.0)
    }
}
