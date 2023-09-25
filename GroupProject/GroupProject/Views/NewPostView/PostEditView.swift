/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Tuan Kiet
  ID: 3879300
  Created  date: 15/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/


import SwiftUI
import Kingfisher
struct PostEditView: View {
    
    @State var status: String = ""
    @ObservedObject var viewModel: PostViewModel
    @Environment(\.dismiss) var dimiss
    var post: Post
    var user: User
    
    var body: some View {
        ZStack{
            Image("theme")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer()
                        HStack(spacing: 16) {
                            KFImage(URL(string: user.profileImageUrl ?? ""))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color(.gray), lineWidth: 3))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(post.username)
                                    .font(.system(size: 16))
                                
                                Text("15 Sep, 2023")
                                    .font(.system(size: 16))
                            }
                            
                            Spacer()
                        }
                        Spacer()
                        Spacer()
                        AsyncImage(url: post.imageUrl)
                            .frame(width: 300, height: 250)
                            .cornerRadius(20.0)
                            .padding(20) // Adjust padding as needed
                        TextField("Write something ...", text: $status, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.87)
                        Button(action: {
                            Task {
                                do {
                                    await viewModel.editPost(postId: post.id, newCaption: status)
                                    //dismiss()
                                }
                            }
                        }) {
                            Text("Save")
                                .font(Font.custom("Baskerville-Bold", size: 26))
                                .frame(width: 100, height: 70)
                                .foregroundColor(.white)
                                .background(Color("Color"))
                                .cornerRadius(30)
                                .shadow(radius: 10)
                                .padding()
                        }
                        Spacer()
                    }
                    .padding()
                    .onAppear {
                        status = post.caption
                    }
                }
            }
        }

    }
}

struct PostEditView_Previews: PreviewProvider {
    static var viewModel = PostViewModel()
    static var previews: some View {
        PostEditView(viewModel: viewModel, post: Post(
            id: "1234567890",
            userId: "userID_12345",
            username: "mockUsername",
            imageUrl: "https://example.com/mock-image.jpg",
            caption: "This is a mock caption for the mock post.",
            like: ["user1", "user2", "user3"],
            category: "All", 
            name: "Sydney", 
            coordinates: Coordinates(latitude: 10.7,longitude: 106.69)
        ), user: User(id: "1", username: "Test", email: "check@gmail.com",followers: [],following: []))
    }
}
