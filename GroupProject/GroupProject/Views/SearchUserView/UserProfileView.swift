/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 11/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
import Firebase
import SDWebImageSwiftUI

import SwiftUI

struct UserProfileView: View {
    var user: User
    @State var currentUser: User
    @Environment(\.presentationMode) private var presentationMode:
    Binding<PresentationMode>
    @ObservedObject var userService = UserService()
    @ObservedObject var viewModel: PostViewModel
    
    @EnvironmentObject var globalSettings: GlobalSettings


    @State private var showEditProfile = false
    @State private var isFollowing = false
    //@State private var refreshFlag = false
    //@State var user: User?
    let scalingFactor: CGFloat
    @Environment (\.dismiss) var dismiss

    var body: some View {
        ZStack{
            
            globalSettings.isDark ? Color("DarkBackground") .ignoresSafeArea() :  Color("LightBackground").ignoresSafeArea()
            
            ScrollView {
                VStack {
                    CircularProfileImageView(user: user, size: .large, scalingFactor: scalingFactor )
                    if user.id == currentUser.id {
                        InfoView(userId: user.id, currentUserId: currentUser.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: false, isCurrentUser: true, followerArray: user.followers, followingArray: currentUser.following)
                    } else if !user.followers.contains("\(currentUser.id)") {
                        InfoView(userId: user.id, currentUserId: currentUser.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: false, isCurrentUser: false, followerArray: user.followers, followingArray: currentUser.following)
                    } else if user.followers.contains("\(currentUser.id)") {
                        InfoView(userId: user.id, currentUserId: currentUser.id, fullName: user.fullname ?? "N/A", bio: user.bio ?? "N/A", follower: user.followers.count, following: user.following.count, isFollow: true, isCurrentUser: false, followerArray: user.followers, followingArray: currentUser.following)
                    }
                }
                
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if !viewModel.dataLoaded {
                    viewModel.fetchUserPosts(userId: currentUser.id)
                }
            }
        }
        .customBackButton(presentationMode: presentationMode)
    }
}

struct InfoView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
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
                .foregroundColor( globalSettings.isDark ? Color("DarkText")  :  Color("BlackText"))
                .font(.footnote)
                .fontWeight(.semibold)
            Text("\(bio)")
                .foregroundColor( globalSettings.isDark ? Color("DarkText")  :  Color("BlackText"))
                .font(.footnote)
            Text("Follower: \(follower)")
                .foregroundColor( globalSettings.isDark ? Color("DarkText")  :  Color("BlackText"))
                .font(.footnote)
            Text("Following: \(following)")
                .foregroundColor( globalSettings.isDark ? Color("DarkText")  :  Color("BlackText"))
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

