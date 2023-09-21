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
    var user: User
    var currentUser: User
    
    @ObservedObject var userService = UserService()

    
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
//            Button {
//                if user.isCurrentUser {
//                    showEditProfile.toggle()
//                    print("Show edit profile")
//                } else if userService.currentUser != nil {
//                    if userService.currentUser!.following.contains(user.id) {
//                        // Show the unfollow button
//                        userService.unfollowUser(userIDToUnfollow: user.id)
//                    } else {
//                        // Show the follow button
//                        userService.followUser(userIDToFollow: user.id)
//                    }
      if user.followers.contains("\(currentUser.id)") {
                    InfoView(userId: user.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: true, isCurrentUser: false)
                } else if user.id == currentUser.id {
                    InfoView(userId: user.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: false, isCurrentUser: true)

                } else {
                    InfoView(userId: user.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: false, isCurrentUser: false)
                }
                }
            LazyVGrid(columns: gridItems, spacing: 1) {
                ForEach(0 ... 5, id: \.self) { index in
                    Image("Login")
                        .resizable()
                        .scaledToFill()

                }

            }
            .background(globalSettings.isDark ? Color.black : Color.white)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
    
    }
    
}

struct InfoView: View {
    @State var userId: String
    @State var fullName: String
    @State var bio: String
    @State var follower: Int
    @State var following: Int
    @State var isFollow: Bool
    @State var isCurrentUser: Bool
    @State private var selectedTab: Int = 3
    
    @ObservedObject var userService = UserService()
    
    func follow() {
        userService.followUser(userIDToFollow: userId)
        follower += 1
    }
    
    func unfollow() {
        userService.unfollowUser(userIDToUnfollow: userId)
        follower -= 1
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(fullName)")
                .font(.footnote)
                .fontWeight(.semibold)
            Text("\(bio)")
                .font(.footnote)
            Text("Follower: \(follower)")
                .font(.footnote)
            Text("Following: \(following)")
                .font(.footnote)
            // Add more user properties here as needed
            
            if isCurrentUser {
                Button() {
                    isFollow.toggle()
                } label: {
                    Text("Follow")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .opacity(0.5)
                        .cornerRadius(6)
                }
                .disabled(true)
            } else {
                Button() {
                    isFollow == true ? unfollow() : follow()
                    isFollow.toggle()
                } label: {
                    Text(isFollow == true ? "Unfollow" : "Follow")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(isFollow == true ? Color.red : Color.blue)
                        .cornerRadius(6)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: User.MOCK_USERS[0], currentUser: User(id: "1", username: "Test", email: "check@gmail.com", followers: [], following: []))
    }
}
