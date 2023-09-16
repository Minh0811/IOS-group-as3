//
//  EditProfileView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 16/09/2023.
//

import SwiftUI
import Firebase
import SwiftUI
import FirebaseStorage
import PhotosUI
struct EditProfileView: View {
    @Environment (\.dismiss) var dismiss
    @ObservedObject var userService = UserService()
    @StateObject var viewModel = EditProfileViewModel()
    @State private var refreshFlag = false
    @State private var fullname = ""
    @State private var bio = ""
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
        
    }
    var body: some View {
        
            VStack{
                VStack{
                    HStack{
                        Button("Cancel"){
                            dismiss()
                        }
                        Spacer()
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        Button{
                            Task { try await viewModel.updateUserData()
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                    dismiss()
//                                }
                                dismiss()
                            }
                            
                        } label: {
                            Text("Done")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                    }
                    .padding(.horizontal)
                    Divider()
                }
                //EDIT PROFILE PIC
                PhotosPicker(selection: $viewModel.selectedImage){
                    VStack{
                        if let image = viewModel.profileImage {
                            image
                                .resizable()
                                .foregroundColor(.white)
                                .background(.gray)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else{
                            if let user = userService.currentUser {
                                CircularProfileImageView(user: user)
                            }
                        }
                        Text("Edit profile picture")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Divider()
                    }
                    
                }
                
                .padding(.vertical, 8)
                //EDIT INFO
                VStack{
                    EditProfileRowView(title: "Name", placeholder: "Enter your name...", text: $viewModel.fullname)
                    EditProfileRowView(title: "Bio", placeholder: "Enter your bio...", text: $viewModel.bio)
                }
                Spacer()
                
            }
            
            .navigationBarBackButtonHidden(true)
            
        
    }
}
struct EditProfileRowView: View{
    let title: String
    let placeholder: String
    @Binding var text: String
    var body: some View{
        HStack{
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
            VStack{
                TextField(placeholder, text: $text )
            }
        }
    }
}
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: User.MOCK_USERS[0])
    }
}
