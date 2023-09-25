/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Vo Khai Minh
  ID: 3879953
  Created  date: 16/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
import Kingfisher

struct PostView: View {
    @ObservedObject var userService = UserService()
    @ObservedObject var viewModel = PostViewModel()
    @EnvironmentObject var globalSettings: GlobalSettings
    @State var currentUser: User?
    let scalingFactor: CGFloat
    @State private var searchText = ""
    @State private var selectedIndex: Int = 0
    private let categories = ["All", "Coffee", "Foods", "Schools", "Street Foods", "Beauty"]
    // var currentUserLike: User
    // var currentUser: User
    
    // Insert the modified filteredPosts here
    var filteredPosts: [Post] {
        var result = viewModel.posts
        
        // Filter based on search text
        if !searchText.isEmpty {
            result = result.filter { post in
                return post.caption.lowercased().contains(searchText.lowercased())
            }

            // Filter based on selected category
            if categories[selectedIndex] != "All" {
                result = result.filter { post in
                    return post.category == categories[selectedIndex]
                }
            }

            return result
        }
        
        // Filter based on selected category
        if categories[selectedIndex] != "All" {
            result = result.filter { post in
                return post.category == categories[selectedIndex]
            }
        }
        
        return result
    }
    
    
    
    var body: some View {
        ZStack{
     
                ScrollView(showsIndicators: false) {
                    HStack {
                        Spacer()
                        VStack(spacing: 20) {
                            
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(0 ..< categories.count) { i in
                                        Button(action: {selectedIndex = i}) {
                                            CategoryView(isActive: selectedIndex == i, text: categories[i], scalingFactor: scalingFactor)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 15)
                            }
                            
                            TextField("Search", text: $searchText)
                                .frame(width: 350 * scalingFactor, height: 30 * scalingFactor)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            ForEach(filteredPosts) { post in
                                ForEach(viewModel.allUsers) { user in
                                    
                                    if let currentUserId = currentUser?.id, user.id == post.userId && post.like.contains(currentUserId) {
                                        CardView(post: post, postOwner: user, currentUser: currentUser ??
                                                 User(id:"", username:"", email:"", followers: [],following: []),
                                                 numOfLike: post.like.count, isLike: true, likeArray: post.like, scalingFactor: scalingFactor)
                                    } else if user.id == post.userId {
                                        CardView(post: post, postOwner: user, currentUser: currentUser ??
                                                 User(id:"", username:"", email:"", followers: [],following: []),
                                                 numOfLike: post.like.count, isLike: false, likeArray: post.like, scalingFactor: scalingFactor)
                                        
                                    }
                                }
                                
                                .navigationBarHidden(true)
                                .foregroundColor(.black)
                            }
                        }
                        Spacer()
                    }
                }
                
                .padding(.bottom)
                .onAppear{
                    viewModel.fetchPosts()
                    currentUser = userService.currentUser
                }
            
        }
    }
}

struct CardView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    var post: Post
    var postOwner: User
    var currentUser: User
    @State var numOfLike: Int
    @State var isLike: Bool
    @State var likeArray: [String]
    let scalingFactor: CGFloat
    @ObservedObject var viewModel = PostViewModel()
    
    func addToLikeArray() {
        likeArray.append("\(currentUser.id)")
        numOfLike += 1
    }
    
    func removeFromLikeArray() {
        likeArray = likeArray.filter() {$0 != "\(currentUser.id)"}
        numOfLike -= 1
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                KFImage(URL(string: postOwner.profileImageUrl ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70 * scalingFactor, height: 50 * scalingFactor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("Color"),lineWidth: 3 * scalingFactor))
                    .padding(.horizontal, 2 * scalingFactor)
                    .padding(.vertical, 2 * scalingFactor)
                
                Text("\(postOwner.username)")
                    .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    .font(.custom("PlayfairDisplay-Regular", size: 18 * scalingFactor))
                    .padding(.trailing, 15 * scalingFactor)
                    .padding(.leading, 5 * scalingFactor)
                Text("\(post.category)")
                    .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    .font(.custom("PlayfairDisplay-Regular", size: 13 * scalingFactor))
                    .padding(.horizontal, 10 * scalingFactor)
                    .padding(.vertical, 5 * scalingFactor)
                    .background(Color("PrimaryText"))
                    .cornerRadius(5 * scalingFactor)
                Spacer()
                
                if postOwner.id == currentUser.id {
                    NavigationLink(destination: PostEditView(viewModel: PostViewModel(), post: post, user: postOwner)) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(-90))
                    }
                }
            }
            
            AsyncImage(url: post.imageUrl)
                .frame(width: 350 * scalingFactor, height: 350 * scalingFactor)
                .cornerRadius(10.0 * scalingFactor)
            HStack(spacing: 2 * scalingFactor) {
                Text(post.caption)
                    .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    .font(.custom("PlayfairDisplay-Regular", size: 23 * scalingFactor))
                    .fontWeight(.light)
            }
            
            Divider()
            
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 10)
                Button() {
                    isLike == true ? removeFromLikeArray() : addToLikeArray()
                    isLike.toggle()
                    viewModel.likePost(postId: post.id, userIdArray: likeArray)
                } label: {
                    Image(systemName: isLike == true ? "heart.fill" : "heart")
                        .foregroundColor(isLike == true ? Color("Color") : globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                        .font(.custom("PlayfairDisplay-Regular", size: 13 * scalingFactor))
                    Text("\(numOfLike)")
                        .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                        .font(.custom("PlayfairDisplay-Regular", size: 13 * scalingFactor))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: CommentView(viewModel: viewModel, scalingFactor: scalingFactor, postId: post.id, post: post)
                        .environmentObject(globalSettings)
                ) {
                    Image(systemName: "bubble.left")
                        .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                        .font(.custom("PlayfairDisplay-Regular", size: 13 * scalingFactor))
                    Text("Comment")
                        .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                        .font(.custom("PlayfairDisplay-Regular", size: 13 * scalingFactor))
                }
            }
        }
        .padding()
        .background(globalSettings.isDark ? Color("DarkPost") :  Color("LightPost"))
        .cornerRadius(20.0)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(globalSettings.isDark ? Color("LightPost") :  Color("DarkPost"), lineWidth: 3)
        )
    }
}

struct CategoryView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    let isActive: Bool
    let text: String
    let scalingFactor: CGFloat
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(size: 18 * scalingFactor))
                .fontWeight(.medium)
                .foregroundColor(isActive ? Color("PrimaryText") : globalSettings.isDark ? Color("DarkText") :  Color("LightText"))
            if (isActive) { Color("PrimaryText")
                    .frame(width: 15, height: 2)
                    .clipShape(Capsule())
            }
        }
        .padding(.trailing, 15 * scalingFactor)
    }
}
