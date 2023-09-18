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
    @EnvironmentObject var appState: AppState
    @State private var isLoggedOut: Bool = false
    @State private var showEditProfile = false
    //@State private var refreshFlag = false
    @State var currentuser: User?
    @Environment (\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack {
                if let user = currentuser { // Check if currentUser is available
                    
                    CircularProfileImageView(user: user )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(user.username)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("Full Name: \(user.fullname ?? "N/A")")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("Bio: \(user.bio ?? "N/A")")
                            .font(.footnote)
                        // Add more user properties here as needed
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                //else {
                //                        Text("Loading user data...")
                //                    }
                
                
                NavigationLink(destination: EditProfileView(viewModel: EditProfileViewModel(user: currentuser ?? User(id: "", username: "", email: "")))) {
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
//                if let currentUser = userService.currentUser {
               
                    userService.fetchCurrentUser()
                    currentuser = userService.currentUser
                
//                currentuser = userService.currentUser
//                }
            }
            .onDisappear {
                
                print("Disappear")
                currentuser = nil
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        
    }
}


struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: User.MOCK_USERS[0])
    }
}


