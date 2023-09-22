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
    @State private var isDropdownVisible = false
    @State private var selectedCategory: String = "All"
    let categories = ["All", "Coffee", "Foods", "Schools", "Street Foods", "Beauty"]
    @EnvironmentObject var globalSettings: GlobalSettings

    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            ZStack{
                Button() {
                    isImagePickerPresented = true
                } label: {
                    Image("img")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    
                }
                .padding(.horizontal)
                Rectangle()
                    .stroke(Color("Primary"), lineWidth: 4)
                    .frame(width: 100, height: 80)
            }


            TextField("Enter caption", text: $caption, axis: .vertical)
                .padding(.horizontal)
                .frame(width: 350, height: 90)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
            
            Button(action: {
                            withAnimation {
                                isDropdownVisible.toggle()
                            }
                        }) {
                            Text(selectedCategory)
                                .font(Font.custom("Baskerville-Bold", size: 18))
                                .foregroundColor(Color("Primary"))
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                     .stroke(Color("Primary"), lineWidth: 1)
                                     
                                )
                        }
                        .padding()
                        
                        if isDropdownVisible {
                            List(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                    withAnimation {
                                        isDropdownVisible.toggle()
                                    }
                                }) {
                                    Text(category)
                                        .font(Font.custom("Baskerville-Bold", size: 18))
                                        .foregroundColor(Color("Primary"))
                                        
                                        
                                }
                            }
                            .frame(width: 280, height: 100)
                            .cornerRadius(8)
                            
                        }
            
            Button() {
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
            } label: {
                Text("Post")
                    .font(Font.custom("Baskerville-Bold", size: 24))
                    .foregroundColor(.black)
                    .padding()
                    .padding(.horizontal)
                    .background(Color("Primary"))
                    .cornerRadius(30)
                    .shadow(radius: 10)
            }
            .disabled(isLoading || selectedImage == nil)
            Spacer()
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
