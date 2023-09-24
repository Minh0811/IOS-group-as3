//
//  PostView.swift
//  GroupProject
//
//  Created by Minh Vo on 16/09/2023.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    @ObservedObject var userService = UserService()
    @ObservedObject var viewModel = PostViewModel()
    @EnvironmentObject var globalSettings: GlobalSettings
    @State var currentUser: User?
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
                                        CategoryView(isActive: selectedIndex == i, text: categories[i])
                                    }
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 15)
                        }
                        
                        TextField("Search", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        ForEach(filteredPosts) { post in
                             ForEach(viewModel.allUsers) { user in
                                    
                                    if let currentUserId = currentUser?.id, user.id == post.userId && post.like.contains(currentUserId) {
                                        CardView(post: post, postOwner: user, currentUser: currentUser ??
                                                 User(id:"", username:"", email:"", followers: [],following: []),
                                                 numOfLike: post.like.count, isLike: true, likeArray: post.like)
                                    } else if user.id == post.userId {
                                        CardView(post: post, postOwner: user, currentUser: currentUser ??
                                                 User(id:"", username:"", email:"", followers: [],following: []),
                                                 numOfLike: post.like.count, isLike: false, likeArray: post.like)
                                        
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




struct PostView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack{
            Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
                .ignoresSafeArea()
            PostView(currentUser: User(id: "1", username: "Test", email: "check@gmail.com",followers: [],following: []))
                .environmentObject(GlobalSettings.shared)
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
                    .frame(width: 70, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("Color"),lineWidth: 3))
                    .padding(.horizontal, 2)
                    .padding(.vertical, 2)
                
                Text("\(postOwner.username)")
                    .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    .font(.custom("PlayfairDisplay-Regular", size: 18))
                    .padding(.trailing, 15)
                    .padding(.leading, 5)
                Text("\(post.category)")
                    .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    .font(.custom("PlayfairDisplay-Regular", size: 13))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("PrimaryText"))
                    .cornerRadius(5)
                Spacer()
                
                if postOwner.id == currentUser.id {
                    NavigationLink(destination: PostEditView(viewModel: PostViewModel(), post: post, user: postOwner)) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(-90))
                    }
                }
            }
            
            AsyncImage(url: post.imageUrl)
                .frame(width: 350, height: 350)
                .cornerRadius(10.0)
            HStack(spacing: 2) {
                Text(post.caption)
                    .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    .font(.title3)
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
                    Text("\(numOfLike)")
                        .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: CommentView(viewModel: viewModel, postId: post.id, post: post)
                        .environmentObject(globalSettings)
                ) {
                    Image(systemName: "bubble.left")
                        .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
                    Text("Comment")
                        .foregroundColor(globalSettings.isDark ? Color("DarkText") :  Color("BlackText"))
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
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(isActive ? Color("PrimaryText") : globalSettings.isDark ? Color("DarkText") :  Color("LightText"))
            if (isActive) { Color("PrimaryText")
                    .frame(width: 15, height: 2)
                    .clipShape(Capsule())
            }
        }
        .padding(.trailing)
    }
}
