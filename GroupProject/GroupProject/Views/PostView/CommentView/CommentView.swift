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
    let scalingFactor: CGFloat
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
                
                DescriptionView(post: post, scalingFactor: scalingFactor)
                    .padding(.horizontal)
                
                ZStack {
                    HStack {
                        CircularProfileImageView(user: currentUser ?? User(id: "N/A", username: "N/A", email: "N/A", followers: [], following: []), size: .small, scalingFactor: scalingFactor )
                            .padding(.leading)
                        Spacer()
                        TextField("Add a comment...", text: $commentText, axis: .vertical)
                            .padding(.horizontal)
                            .frame(width: 200 * scalingFactor, height: 40 * scalingFactor)
                            .background(Color.white)
                            .cornerRadius(8)
                            .font(.custom("PlayfairDisplay-Regular", size: 18 * scalingFactor))
                        Spacer()
                        ZStack {
                            Image(systemName: "paperplane.fill")
                                .frame(width: 40 * scalingFactor, height: 40 * scalingFactor)
                                .foregroundColor(globalSettings.isDark ? Color("DarkBackground") : Color.white)
                        }
                        .frame(width: 40 , height: 40 )
                        .background(globalSettings.isDark ? Color("DarkBackground") : Color("Color 2"))
                        .cornerRadius(20  * scalingFactor)
                        //.shadow(radius: 5)
                        .padding(.trailing, 15  * scalingFactor)
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
                    .frame(height: 75 * scalingFactor)
                    .background(globalSettings.isDark ? Color("DarkBackground") : Color("Color"))
                }
                    .padding(.vertical, 10 * scalingFactor)
                
                AllComments(viewModel: viewModel, globalSettings: _globalSettings, scalingFactor: scalingFactor)
                .frame(width: 350 * scalingFactor, height: 75 * scalingFactor)
                .background(Color.white)
                .cornerRadius(5 * scalingFactor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20 * scalingFactor)
                        .stroke(globalSettings.isDark ? Color("LightPost") :  Color("DarkPost"), lineWidth: 1 * scalingFactor)
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



struct DescriptionView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    var post: Post
    let scalingFactor: CGFloat
    var body: some View {
        VStack (alignment: .leading) {
            //Title
            Text(post.username)
                .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                .font(.custom("PlayfairDisplay-Regular", size: 18 * scalingFactor))
            
            HStack (spacing: 4) {
                Text(post.caption)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    .font(.custom("PlayfairDisplay-Regular", size: 13 * scalingFactor))
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

struct AddComment: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    @ObservedObject var viewModel: PostViewModel
    let postId: String
    var post: Post
    var currentUser: User?
    @State private var commentText: String = ""
    let scalingFactor: CGFloat
    var body: some View {
        ZStack {
            HStack {
                CircularProfileImageView(user: currentUser ?? User(id: "N/A", username: "N/A", email: "N/A", followers: [], following: []), size: .small, scalingFactor: scalingFactor )
                    .padding(.leading)
                Spacer()
                TextField("Add a comment...", text: $commentText, axis: .vertical)
                    .padding(.horizontal)
                    .frame(width: 200 * scalingFactor, height: 40 * scalingFactor)
                    .background(Color.white)
                    .cornerRadius(8)
                    .font(.custom("PlayfairDisplay-Regular", size: 18 * scalingFactor))
                Spacer()
                ZStack {
                    Image(systemName: "paperplane.fill")
                        .frame(width: 40 * scalingFactor, height: 40 * scalingFactor)
                        .foregroundColor(globalSettings.isDark ? Color("DarkBackground") : Color.white)
                }
                .frame(width: 40 , height: 40 )
                .background(globalSettings.isDark ? Color("DarkBackground") : Color("Color 2"))
                .cornerRadius(20  * scalingFactor)
                //.shadow(radius: 5)
                .padding(.trailing, 15  * scalingFactor)
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
            .frame(height: 75 * scalingFactor)
            .background(globalSettings.isDark ? Color("DarkBackground") : Color("Color"))
        }
    }
}

struct AllComments: View {
    @ObservedObject var viewModel: PostViewModel
    @EnvironmentObject var globalSettings: GlobalSettings
    let scalingFactor: CGFloat
    
    var body: some View {
        ForEach(viewModel.comments) { comment in
            HStack() {
                VStack{
                    HStack(alignment: .top) {
                        ForEach(viewModel.allUsers) { user in
                            if user.id == comment.userId {
                                CircularProfileImageView(user: user, size: .small, scalingFactor: scalingFactor)
                                    .padding(.trailing, 5)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(comment.username)
                                .bold()
                                .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                                .font(.custom("PlayfairDisplay-Regular", size: 18 * scalingFactor))
                            Text(comment.text)
                                .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                                .font(.custom("PlayfairDisplay-Regular", size: 18 * scalingFactor))
                        }
                    }
                }
                Spacer()
            }
            .padding(.vertical, 5 * scalingFactor)
            .padding(.horizontal, 15 * scalingFactor)
        }
    }
}
