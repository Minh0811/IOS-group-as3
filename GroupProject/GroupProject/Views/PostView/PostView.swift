//
//  PostView.swift
//  GroupProject
//
//  Created by Minh Vo on 16/09/2023.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    
    @ObservedObject var viewModel = PostViewModel()

   
    @State private var searchText = ""
   
    var currentUser: User
    var categories = ["Coffee", "Foods", "Schools", "Street Foods", "Beauty", "etx..."]
    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { post in
                
                let postcaption = post.caption.lowercased().contains(searchText.lowercased())
                return  postcaption
            }
        }
    }

    

    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    ForEach(filteredPosts) { post in
                        NavigationLink(
                            destination: DetailView(post: post),
                            label: { ForEach(viewModel.allUsers) { user in

                                if user.id == post.userId && post.like.contains("\(currentUser.id)"){
                                    CardView(post: post, postOwner: user, currentUser: currentUser, isLike: true, likeArray: post.like)
                                } else if user.id == post.userId {
                                    CardView(post: post, postOwner: user, currentUser: currentUser, isLike: false, likeArray: post.like)

                                }
                            }
                            })
                        .navigationBarHidden(true)
                        .foregroundColor(.black)
                    }
                }
                Spacer()
            }
        }
        .padding(.bottom)
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}

struct CardView: View {
    var post: Post
    var postOwner: User
    var currentUser: User
    @State var isLike: Bool
    @State var likeArray: [String]
    
    @ObservedObject var viewModel = PostViewModel()
    
    func addToLikeArray() {
        likeArray.append("\(currentUser.id)")
    }
    
    func removeFromLikeArray() {
        likeArray = likeArray.filter() {$0 != "\(currentUser.id)"}
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                KFImage(URL(string: postOwner.profileImageUrl ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.gray),lineWidth: 3))
                
                Text("\(postOwner.username)")
                
                Spacer()
                
                if postOwner.id == currentUser.id {
                    NavigationLink(destination: PostEditView(viewModel: PostViewModel(), post: post)) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(-90))
                    }
                }
            }
            
            Divider()
            
            AsyncImage(url: post.imageUrl)
                .frame(width: 320, height: 320)
                .cornerRadius(20.0)
            HStack(spacing: 2) {
                
                Text(post.caption)
                    .font(.title3)
                    .fontWeight(.light)
                
            }
            
            Divider()
            HStack(spacing: 0) {
                
                
                HStack(spacing: 0) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                    
                    Spacer()
                        .frame(width: 5)
                    Text("\(post.like.count)")
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Image(systemName: "text.bubble")
                    Spacer()
                        .frame(width: 5)
                    Text("21")
                }
                .padding(.horizontal, 10)
            }
            
            Divider()
            HStack(spacing: 0) {
                
                Spacer()
                    .frame(width: 10)
                Button() {
                    isLike == true ? removeFromLikeArray() : addToLikeArray()
                    viewModel.likePost(postId: post.id, userIdArray: likeArray)
                } label: {
                    Image(systemName: isLike == true ? "heart.fill" : "heart")
                        .foregroundColor(isLike == true ? .pink : .black)
                    Text("Like")
                }
                
                Spacer()
                Button() {
                    
                } label: {
                    Image(systemName: "bubble.left")
                    Text("Comment")
                }
                
                Spacer()
                    .frame(width: 10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20.0)
    }
}



struct PostView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack{
            Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
                .ignoresSafeArea()
            PostView(currentUser: User(id: "1", username: "Test", email: "check@gmail.com"))
        }
    }
}
