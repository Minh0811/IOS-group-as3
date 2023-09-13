//
//  EditProfileView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 12/09/2023.
//

import SwiftUI
import Firebase
import SwiftUI
import FirebaseStorage
import PhotosUI
struct EditProfileView: View {
    @Environment (\.dismiss) var dismiss
    @StateObject var viewModel = EditProfileViewModel()
    
   
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
                        Task { try await viewModel.updateUserData() }
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
                        Image("Login")
                            .resizable()
                            .foregroundColor(.white)
                            .background(.gray)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
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
                Text("Name:")
                Text("Bio:")
            }
           Spacer()
        }
    }
}
//struct EditProfileRowView: View{
//    let title: String
//    let placeholder: String
//    var body: some View{
//        HStack{
//            Text(title)
//                .padding(.leading, 8)
//                .frame(width: 100, alignment: .leading)
//            VStack{
//                TextField(placeholder, text: )
//            }
//        }
//    }
//}
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
