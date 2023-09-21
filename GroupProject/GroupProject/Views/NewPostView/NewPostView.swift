//
//  NewPostView.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import SwiftUI

struct NewPostView: View {
    @State private var selectedImage: UIImage?
    @State private var caption: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var isLoading: Bool = false
    @State private var postCreatedSuccessfully: Bool = false
    
    @State private var selectedCategory: String = "All"
    let categories = ["All", "Coffee", "Foods", "Schools", "Street Foods", "Beauty"]
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Button("Select Image") {
                isImagePickerPresented = true
            }

            TextField("Enter caption", text: $caption)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Picker("Select Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("Create Post") {
                Task {
                    isLoading = true
                    do {
                        let success = try await PostService().createPost(image: selectedImage!, caption: caption, category: selectedCategory)

                        postCreatedSuccessfully = success
                    } catch {
                        // Handle error
                        print(error.localizedDescription)
                    }
                    isLoading = false
                }
            }
            .disabled(isLoading || selectedImage == nil)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            NewPostImagePicker(selectedImage: $selectedImage)
        }
        .alert(isPresented: $postCreatedSuccessfully) {
            Alert(title: Text("Success"), message: Text("Post created successfully!"), dismissButton: .default(Text("OK")))
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
