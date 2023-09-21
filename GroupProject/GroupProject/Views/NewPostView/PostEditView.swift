//
//  PostEditView.swift
//  GroupProject
//
//  Created by Kiet Tran Tuan on 15/09/2023.
//

import SwiftUI

struct PostEditView: View {
    
    @State var status: String = ""
    @ObservedObject var viewModel: PostViewModel
    @Environment(\.dismiss) var dimiss
    var post: Post
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack (spacing: 0){
                    HStack (spacing: 0){
                        
                        //use's profile image
                        Image("user")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.gray),lineWidth: 3))
                
                        VStack(spacing: 0) {
                            //username
                            Text(post.username)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                            //uploaded date of status
                            Text("15 Sep, 2023")
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                        }
                        
                                                
                        Spacer()
                            .frame(width: geometry.size.width * 0.5)
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.04)
                    //edit text field
                    VStack(spacing: 0) {
                        TextField("Write something ...", text: $status, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.87)
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.width * 0.08)
                    //status's image
                    AsyncImage(url: post.imageUrl)
                        
                        .frame(width: UIScreen.main.bounds.width, height: geometry.size.height * 0.45)
                        .cornerRadius(20.0)
                    
                    Button("Save") {
                        Task {
                            do {
                                await viewModel.editPost(postId: post.id, newCaption: status)
                                dimiss()
                            }
                        }
                    }
                }
                .onAppear {
                    status = post.caption
                }
            }
        }
    }
}

struct PostEditView_Previews: PreviewProvider {
    static var previews: some View {
        PostEditView(viewModel: PostViewModel(), post: Post(id: "1", userId: "2", username: "Test", imageUrl: "None", caption: "Caption", like: [], category: "All"))
    }
}
