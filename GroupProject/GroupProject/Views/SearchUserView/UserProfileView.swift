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
    @State var currentUser: User
    
    @ObservedObject var userService = UserService()
    
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
                if user.id == currentUser.id {
                    InfoView(userId: user.id, currentUserId: currentUser.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: false, isCurrentUser: true, followerArray: user.followers, followingArray: currentUser.following)
                } else if !user.followers.contains("\(currentUser.id)") {
                    InfoView(userId: user.id, currentUserId: currentUser.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: false, isCurrentUser: false, followerArray: user.followers, followingArray: currentUser.following)
                } else if user.followers.contains("\(currentUser.id)") {
                   InfoView(userId: user.id, currentUserId: currentUser.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: true, isCurrentUser: false, followerArray: user.followers, followingArray: currentUser.following)
               }
                }
            LazyVGrid(columns: gridItems, spacing: 1) {
                ForEach(0 ... 5, id: \.self) { index in
                    Image("Login")
                        .resizable()
                        .scaledToFill()

                }
            }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
    
    }
    
}

struct InfoView: View {
    @State var userId: String
    @State var currentUserId: String
    @State var fullName: String
    @State var bio: String
    @State var follower: Int
    @State var following: Int
    @State var isFollow: Bool
    @State var isCurrentUser: Bool
    @State var followerArray: [String]
    @State var followingArray: [String]
    
    @ObservedObject var userService = UserService()
    @ObservedObject var viewModel = SearchViewModel()
    
    func follow() {
        followerArray.append("\(currentUserId)")
        followingArray.append("\(userId)")
//        print(followingArray)
        follower += 1
    }
    
    func unfollow() {
        followerArray = followerArray.filter() {$0 != "\(currentUserId)"}
        followingArray = followingArray.filter() {$0 != "\(userId)"}
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
                    userService.followUser(userId: userId, currentUserId: currentUserId, followerArray: followerArray, followingArray: followingArray)
//                    viewModel.fetchAllUsers()
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
