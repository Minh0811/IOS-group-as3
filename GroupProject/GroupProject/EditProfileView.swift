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
    @State private var selectedImage: UIImage?
    @ObservedObject private var imageUploadModel = ImageUploadModel()
    //@State private var selectedImage: Photos
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
            VStack{
                if let selectedImage = selectedImage{
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                } else {
                    Text("No image selected")
                }

                            Button("Upload Image") {
                                if let selectedImage = selectedImage {
                                    imageUploadModel.uploadImage(image: selectedImage)
                                }
                            }
                            .padding()

                            if let uploadedImageUrl = imageUploadModel.uploadedImageUrl {
                                Text("Uploaded Image URL: \(uploadedImageUrl)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }

                            if let uploadError = imageUploadModel.uploadError {
                                Text("Upload Error: \(uploadError)")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                Divider()
            }
            .padding(.vertical, 8)
            //EDIT INFO
            VStack{
                Text("Name:")
                Text("Caption")
            }
           Spacer()
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
