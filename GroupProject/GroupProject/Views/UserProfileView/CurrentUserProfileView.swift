//
//  CurrentUserProfileView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 17/09/2023.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import Kingfisher

struct CurrentUserProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"
    @ObservedObject var userService = UserService()
    @ObservedObject var viewModel = PostViewModel()
    @EnvironmentObject var appState: AppState
    @State private var isLoggedOut: Bool = false
    @State var currentUser: User?
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                if let user = currentUser {
                    HStack{
                        CircularProfileImageView(user: user, size: .large )
                        Spacer()
                        Button(action: {
                            if colorScheme == .dark {
                                selectedAppearance = "light"
                            } else {
                                selectedAppearance = "dark"
                            }
                        }) {
                            HStack {
                                if colorScheme == .dark {
                                    Image(systemName: "sun.max.fill")
                                        .font(.headline)
                                               .padding(8)
                                               
                                               .background(colorScheme == .dark ? Color.black : Color.white)
                                               .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                               .cornerRadius(10)
                                               .overlay(
                                                   RoundedRectangle(cornerRadius: 10)
                                                       .stroke(Color.gray, lineWidth: 1)
                                               )
                                } else {
                                    Image(systemName: "moon.fill")
                                        .font(.headline)
                                               .padding(8)
                                               
                                               .background(colorScheme == .dark ? Color.black : Color.white)
                                               .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                               .cornerRadius(10)
                                               .overlay(
                                                   RoundedRectangle(cornerRadius: 10)
                                                       .stroke(Color.gray, lineWidth: 1)
                                               )
                                }
                    
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(user.id)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("\(user.username)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("\(user.fullname ?? "N/A")")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("\(user.bio ?? "N/A")")
                            .font(.footnote)
                        Text("Followers: \(user.followers.count)")
                            .font(.footnote)
                        Text("Following: \(user.following.count)")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                }
                
                NavigationLink(destination: EditProfileView(viewModel: EditProfileViewModel(user: currentUser ?? User(id: "", username: "", email: "", followers: [], following: [])))) {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 32)
                        .foregroundColor(.gray)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
               
//                VStack(spacing: 20) {
//                    ForEach(viewModel.userPosts) { post in
//
//                        NavigationLink(
//                            destination: DetailView(),
//                            label: {
//                                UserPostView(post: post)
//                            })
//                        .navigationBarHidden(true)
//                        .foregroundColor(.black)
//                    }
//                }
                //currentUser: currentuser ?? User(id: "", username: "", email: "")
                CurrentUserPostView(viewModel: viewModel, currentUser: currentUser ?? User(id: "", username: "", email: "", followers: [], following: []))
          

                Button(action: {
                    userService.logoutUser()
                    appState.isUserLoggedIn = false
                    appState.resetNavigation() // Reset the navigation
                }) {
                    Text("Logout")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
            }
            .onAppear {
                userService.fetchCurrentUser()
                currentUser = userService.currentUser
                if let userId = currentUser?.id {
                    viewModel.fetchUserPosts(userId: userId)
                }
            }
            .onDisappear {
                currentUser = nil
            }
        }
        .preferredColorScheme(selectedAppearance == "dark" ? .dark : .light)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}
//struct UserPostsView: View {
//    let post: Post
//    
//    var body: some View {
//        VStack {
//            AsyncImage(url: post.imageUrl)
//                .frame(width: 320, height: 200)
//                .cornerRadius(20.0)
//            
//            HStack(spacing: 2) {
//                Text(post.userId)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                Text(post.username)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                Text(post.caption)
//                    .font(.title3)
//                    .fontWeight(.light)
//                NavigationLink(destination: PostEditView(viewModel: PostViewModel(), post: post)) {
//                    Text("Edit")
//                }
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(20.0)
//    }
//}
struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView()
    }
}
