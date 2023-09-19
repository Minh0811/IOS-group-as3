//
//  PostView.swift
//  GroupProject
//
//  Created by Minh Vo on 16/09/2023.
//

import SwiftUI

struct PostView: View {
    
    @State private var search: String = ""
    @State private var selectedIndex: Int = 1
    private var categories = ["Coffee", "Foods", "Schools", "Street Foods", "Beauty", "etx..."]
    
    @ObservedObject var viewModel = PostViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(
                            destination: DetailView(),
                            label: {
                                CardView(post: post)
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
    let post: Post
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                Image("user")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.gray),lineWidth: 3))
                Text("Username")
                
                Spacer()
                Button() {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(-90))
                }
            }
            
            Divider()
            
            AsyncImage(url: post.imageUrl)
                .frame(width: 320, height: 200)
                .cornerRadius(20.0)
            
            HStack(spacing: 2) {
                Text(post.username)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(post.caption)
                    .font(.title3)
                    .fontWeight(.light)
                NavigationLink(destination: PostEditView(viewModel: PostViewModel(), post: post)) {
                    Text("Edit")
                }
            }
            
            Divider()
            HStack(spacing: 0) {
                
                Spacer()
                HStack(spacing: 0) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                    
                    Spacer()
                        .frame(width: 5)
                    Text("1000")
                }
                
                Spacer()
                    .frame(width: 30)
                HStack(spacing: 0) {
                    Image(systemName: "text.bubble")
                    Spacer()
                        .frame(width: 5)
                    Text("21")
                }
            }
            
            Divider()
            HStack(spacing: 0) {

                Spacer()
                    .frame(width: 10)
                Button() {
                    
                } label: {
                    Image(systemName: "heart")
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
            PostView()
        }
    }
}
