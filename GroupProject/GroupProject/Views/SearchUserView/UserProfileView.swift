//
//  ProfileUserView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userService = UserService()
    let user: User
    @EnvironmentObject var globalSettings: GlobalSettings
    @State private var showEditProfile = false
    @State private var isFollowing = false
    //@State private var refreshFlag = false
    //@State var user: User?
    @Environment (\.dismiss) var dismiss
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    var body: some View {
        ScrollView {
            VStack {
                CircularProfileImageView(user: user, size: .large )
                
                VStack(alignment: .leading, spacing: 4) {
                    if let fullname = user.fullname {
                        Text(fullname)
                            .font(.footnote)
                            .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                            .fontWeight(.semibold)
                    }
                    if let bio = user.bio {
                        Text(bio)
                            .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                            .font(.footnote)
                    }
                    Text("Follower: \(user.followers.count)")
                        .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                        .font(.footnote)
                    Text("Following: \(user.following.count)")
                        .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                        .font(.footnote)
                    // Add more user properties here as needed
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            Button {
                if user.isCurrentUser {
                    showEditProfile.toggle()
                    print("Show edit profile")
                } else if userService.currentUser != nil {
                    if userService.currentUser!.following.contains(user.id) {
                        // Show the unfollow button
                        userService.unfollowUser(userIDToUnfollow: user.id)
                    } else {
                        // Show the follow button
                        userService.followUser(userIDToFollow: user.id)
                    }
                } else {
                    print("Follow user...")
                }
            } label: {
                if user.isCurrentUser {
                    Text("Edit Profile")
                } else if userService.currentUser != nil {
                    if userService.currentUser!.following.contains(user.id) {
                        Text("Unfollow")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(6)
                    } else {
                        Text("Follow")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(6)
                    }
                }
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .frame(width: 360, height: 32)
            .background(user.isCurrentUser ? .white : .white)
            .foregroundColor(user.isCurrentUser ? .black : .white)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(user.isCurrentUser ? .gray : .clear, lineWidth: 1))
            LazyVGrid(columns: gridItems, spacing: 1) {
                ForEach(0 ... 5, id: \.self) { index in
                    Image("Login")
                        .resizable()
                        .scaledToFill()

                }
            }
            }
            .background(globalSettings.isDark ? Color.black : Color.white)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)


    
    }
    
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: User.MOCK_USERS[0])
    }
}
