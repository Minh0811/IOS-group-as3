//
//  ProfileUserView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct UserProfileView: View {
    @ObservedObject var userService = UserService()
    @EnvironmentObject var appState: AppState
    @State private var isLoggedOut: Bool = false
    @State private var showEditProfile = false
    @State private var refreshFlag = false
    @State var user: User?
    var body: some View {
        ScrollView {
            VStack {
                if let user = userService.currentUser { // Check if currentUser is available
                    
                    CircularProfileImageView(user: user )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("Full Name: \(user.fullname ?? "N/A")")
                        Text("Bio: \(user.bio ?? "N/A")")
                        // Add more user properties here as needed
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                //else {
                //                        Text("Loading user data...")
                //                    }
                
                
                NavigationLink(destination: EditProfileView(viewModel: EditProfileViewModel(user: user ?? User(id: "", username: "", email: "")))) {
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
                
                //                    .fullScreenCover(isPresented: $showEditProfile) {
                //                        if let user = userService.currentUser {
                //                                                    EditProfileView(user: user)
                //                            } else {
                //                            Text("User data not available for editing.")
                //                            }
                //                    }
                Button(action: {
                    userService.fetchCurrentUser()
                    refreshFlag.toggle()
                }) {
                    Text("Refresh View")
                }
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
                print("Appear")
                if let currentUser = userService.currentUser {
                    user = currentUser
                }
            }
            .onDisappear {
                print("Disappear")
                user = nil
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .id(refreshFlag)
        
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

