//
//  CommentView.swift
//  GroupProject
//
//  Created by Minh Vo on 20/09/2023.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel: PostViewModel
    let postId: String
    @State private var commentText: String = ""
    @State var currentUser: User?
    var body: some View {
        VStack {
            // Input field and button to post a comment
            HStack {
                TextField("Add a comment...", text: $commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Post") {
                    print("Post button pressed.")
                    if let currentUser = currentUser {
                        print("Current user is authenticated with ID: \(currentUser.id)")
                        viewModel.postComment(text: commentText, by: currentUser, for: postId)
                        commentText = ""  // Clear the input field after posting
                    } else {
                        print("User is not authenticated.")
                    }
                }
                .disabled(currentUser == nil)

            }
            .padding()

            // List of comments
            Text("head")
            List(viewModel.comments, id: \.self) { comment in
                VStack(alignment: .leading) {
                    Text("Comments")
                    Text(comment.username).bold()
                    Text(comment.text)
                }
            }
            Text("bottom")
        }
        .onAppear {
            viewModel.fetchComments(for: postId)
            UserService().fetchCurrentUser { user in
                self.currentUser = user
            }
        }

    }
}



struct CommentView_Previews: PreviewProvider {
    static var mockViewModel = PostViewModel()  // Create a mock view model
    static var mockPostId = "123456"  // Provide a mock post ID

    static var previews: some View {
        CommentView(viewModel: mockViewModel, postId: mockPostId)
    }
}

