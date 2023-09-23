
//
//  DetailView.swift
//  GroupProject
//
//  Created by Minh Vo on 15/09/2023.
//

//
//  DetailScreen.swift
//  Furniture_app
//
//  Created by Abu Anwar MD Abdullah on 15/2/21.
//

import SwiftUI

struct DetailView: View {
    var post: Post
    @ObservedObject var viewModel: PostViewModel
    //@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var navigateToCommentView = false
    var body: some View {
        ZStack {
            
            Color("Bg")
            ScrollView  {
                //            Product Image
                
                AsyncImage(url: post.imageUrl)
                    .aspectRatio(1,contentMode: .fit)
                    .edgesIgnoringSafeArea(.top)
                
                DescriptionView(post: post)
                
                NavigationLink(destination: CommentView(viewModel: viewModel, postId: post.id, post: post)) {
                    HStack {
                        Text("Comment View")
                    }
                    .frame(width: 200, height: 60)
                    .background(ZStack{
                        Color(hue: 1.0, saturation: 0.064, brightness: 0.38)
                        RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(.white).blur(radius: 3)
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            
        }
        .onAppear{
            print("DetailView is appearing for postId: \(post.id)")
           // viewModel.fetchComments(for: post.id)
            print("Finished DetailView .onAppear for postId: \(post.id)")
        }
        .onChange(of: viewModel.posts) { newPosts in
            print("DetailView: posts were updated. New count: \(newPosts.count)")
        }
        
        //.navigationBarBackButtonHidden(true)
        //.customBackButton(presentationMode: presentationMode)
        // .toolbarBackground(.hidden, for: .navigationBar)
        // .toolbarBackground(.hidden, for: .tabBar)
    }
}




struct DetailView_Previews: PreviewProvider {
    static let mockPost = Post(
        id: "1234567890",
        userId: "userID_12345",
        username: "mockUsername",
        imageUrl: "https://example.com/mock-image.jpg",
        caption: "This is a mock caption for the mock post.",
        like: ["user1", "user2", "user3"],
        category: "All",
        name: "Sydney",
        coordinates: Coordinates(latitude: 10,longitude: 10)
    )
    static var mockViewModel = PostViewModel()
    static var previews: some View {
        DetailView(post: mockPost, viewModel: mockViewModel)
    }
}

struct DescriptionView: View {
    var post: Post
    
    var body: some View {
        VStack (alignment: .leading) {
            //                Title
            Text(post.username)
                .font(.title)
                .fontWeight(.bold)
            //                Rating
            HStack (spacing: 4) {
                Text(post.caption)
                    .font(.title3)
                    .fontWeight(.light)
                    .padding(.vertical, 3)
                
                Spacer()
            }
            
            
            
        }
        .padding()
        .padding(.top)
        .background(Color("Bg"))
        .opacity(0.8)
        .cornerRadius(15)
        //.cornerRadius(30, corners: [.topLeft, .topRight])
        //.offset(x: 0, y: -30.0)
    }
}


