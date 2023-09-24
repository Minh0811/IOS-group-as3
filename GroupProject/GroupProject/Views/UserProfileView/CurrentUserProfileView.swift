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
    @ObservedObject var userService = UserService()
    @ObservedObject var viewModel = PostViewModel()
    @EnvironmentObject var appState: AppState
    @State private var isLoggedOut: Bool = false
    @State var currentUser: User?
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var globalSettings: GlobalSettings

    
    var body: some View {
       
        
            ScrollView {
                
                VStack {
                    if let user = currentUser {
                        HStack{
                            CircularProfileImageView(user: user, size: .large )
                            Spacer()
                            Text("Followers: \(user.followers.count)")
                                .font(.footnote)
                                .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                            Spacer()
                            Text("Following: \(user.following.count)")
                                .font(.footnote)
                                .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                            Spacer()
                            Button(action: {
                                userService.fetchCurrentUser { user in
                                    self.currentUser = user
                                }
                            }) {
                                Image(systemName: "gobackward")
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(user.username)")
                                .font(.footnote)
                                .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                                .fontWeight(.semibold)
                            Text("\(user.fullname ?? "N/A")")
                                .font(.footnote)
                                .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                                .fontWeight(.semibold)
                            Text("\(user.bio ?? "N/A")")
                                .font(.footnote)
                                .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                           
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                    }
                    
                    NavigationLink(destination: EditProfileView(viewModel: EditProfileViewModel(user: currentUser ?? User(id: "", username: "", email: "", followers: [], following: []))).environmentObject(globalSettings)) {
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
                    // Perform an action when the button is tapped (optional)
                    
                   
                    
                }
                .onAppear {
                    userService.fetchCurrentUser { user in
                        self.currentUser = user
                        if let userId = user?.id {
                            viewModel.fetchUserPosts(userId: userId)
                        }
                    }
                }
                .onDisappear {
                    currentUser = nil
                }

        }
        .background(globalSettings.isDark ? Color.black : Color.white)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView()
            .environmentObject(GlobalSettings.shared)
    }
}
