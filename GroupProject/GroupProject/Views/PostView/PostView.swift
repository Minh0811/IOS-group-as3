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
    @State var currentUser: User?
    var categories = ["Coffee", "Foods", "Schools", "Street Foods", "Beauty", "etx..."]
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(
                            destination: DetailView(post: post, viewModel: viewModel),
                            label: { ForEach(viewModel.allUsers) { user in
                                if user.id == post.userId {
                                    CardView(post: post, postOwner: user, currentUser: currentUser ?? User(id: "", username: "", email: ""))
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
            currentUser = userService.currentUser
        }
    }
}

struct CardView: View {
    let post: Post
    var postOwner: User
    let currentUser: User
    @State private var isLike = false
    
    func checkIsLike() {
        if post.like.contains(postOwner.id) {
            isLike = true
        }
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
        .onAppear {
            checkIsLike()
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
            PostView()
        }
    }
}
