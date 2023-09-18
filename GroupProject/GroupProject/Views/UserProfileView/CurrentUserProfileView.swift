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
    //@State private var showEditProfile = false
    //@State private var refreshFlag = false
    @State var currentuser: User?
    @Environment (\.dismiss) var dismiss
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                if let user = currentuser { // Check if currentUser is available
                    HStack{
                        CircularProfileImageView(user: user, size: .large )
                        Spacer()
                        Button(action: {
                            userService.fetchCurrentUser()
                        }) {
                            Image(systemName: "gobackward")
                            
                        }

                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(user.username)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("\(user.fullname ?? "N/A")")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("\(user.bio ?? "N/A")")
                            .font(.footnote)
                        // Add more user properties here as needed
//                        VStack { // Display followers and following counts
//                            Text("Followers: \(userService.currentUser?.followers.count ?? 0)")
//                            Text("Following: \(userService.currentUser?.following.count ?? 0)")
//                                               }
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
                LazyVGrid(columns: gridItems, spacing: 1) {
                    ForEach(0 ... 5, id: \.self) { index in
                        Image("Login")
                            .resizable()
                            .scaledToFit()
                    }
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
        CurrentUserProfileView()
    }
}


