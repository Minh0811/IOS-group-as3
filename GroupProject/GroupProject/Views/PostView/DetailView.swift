
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
                        //.resizable()
                        .aspectRatio(1,contentMode: .fit)
                        .edgesIgnoringSafeArea(.top)
                
                DescriptionView(post: post)
               
                NavigationLink(
                    destination: CommentView(viewModel: viewModel, postId: post.id),
                    isActive: $navigateToCommentView,
                    label: { EmptyView() }
                )

                Button("CommentView") {
                    navigateToCommentView = true
                }


               
            }
            .edgesIgnoringSafeArea(.top)
            
           
        }
        .onAppear{
            print("DetailView is appearing for postId: \(post.id)")
            viewModel.fetchComments(for: post.id)
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
        like: ["user1", "user2", "user3"]
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
        //.cornerRadius(30, corners: [.topLeft, .topRight])
        //.offset(x: 0, y: -30.0)
    }
}


