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
    
    @ObservedObject var viewModel: EditProfileViewModel
    @State private var isImagePickerPresented: Bool = false
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Image
            if let profileImage = viewModel.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
            }

            
            Button("Change Profile Picture") {
                isImagePickerPresented.toggle()
            }
            .fullScreenCover(isPresented: $isImagePickerPresented) {
                UserImagePicker(selectedImage: Binding<UIImage?>(get: {
                    self.viewModel.uiImage
                }, set: { selectedImage in
                    if let unwrappedImage = selectedImage {
                        self.viewModel.loadImage(from: unwrappedImage)
                    }
                }))

            }


            // Full Name
            TextField("Full Name", text: $viewModel.fullname)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            // Bio
            TextField("Bio", text: $viewModel.bio)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            // Save Button
            Button("Save Changes") {
                Task {
                    do {
                        try await viewModel.updateUserData()
                        
                            dismiss()
                        
                    } catch {
                        // Handle error
                        print("Failed to update user data: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
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
        let viewModel = EditProfileViewModel(user: User.MOCK_USERS[0])
        EditProfileView(viewModel: viewModel)
    }
}

