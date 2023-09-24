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
        ScrollView{
            VStack {
                SelectImage(isImagePickerPresented: $isImagePickerPresented, selectedImage: $selectedImage)
                    .background()
                    .opacity(1)
                    .cornerRadius(30)
                
                
                ChooseCaption(caption: $caption)
                
                ChooseCategory(isDropdownVisible: $isDropdownVisible, selectedCategory: $selectedCategory, categories: categories)
                
                PostButton(isLoading: $isLoading, postCreatedSuccessfully: $postCreatedSuccessfully, selectedImage: selectedImage, caption: caption, selectedCategory: selectedCategory)
                
                
            }
        }
        .background(Image("theme"))
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

struct SelectImage: View {
    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        Button() {
            isImagePickerPresented = true
        } label: {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.top)
                } else {
                    Image("img")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.top)
                }
                Text("Choose your image")
                    .fontWeight(.semibold)
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding([.leading, .bottom, .trailing])
            }
        }
    }
}


struct ChooseCaption: View {
    @Binding var caption: String
    
    var body: some View {
        TextField("Enter caption", text: $caption, axis: .vertical)
            .padding(.horizontal)
            .frame(width: 300, height: 70)
            .background(Color.white)
            .cornerRadius(8)
            .padding()
    }
}

struct ChooseCategory: View {
    @Binding var isDropdownVisible: Bool
    @Binding var selectedCategory: String
    @EnvironmentObject var globalSettings: GlobalSettings
    let categories: [String]
    
    var body: some View {
        VStack {
            Text("Choose a category:")
                .font(Font.custom("Baskerville-Bold", size: 23))
            Button(action: {
                withAnimation {
                    isDropdownVisible.toggle()
                }
            }) {
                Text(selectedCategory)
                    .font(Font.custom("Baskerville-Bold", size: 18))
                    .foregroundColor(Color("Color"))
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("Color"), lineWidth: 1)
                    )
            }
            .padding()
            
            if isDropdownVisible {
                ZStack {
                    globalSettings.isDark ? Color("LightPost").ignoresSafeArea() : Color("DarkPost").ignoresSafeArea()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                    withAnimation {
                                        isDropdownVisible.toggle()
                                    }
                                }) {
                                    Text(category)
                                        .font(Font.custom("Baskerville-Bold", size: 18))
                                        .foregroundColor(Color("Color"))
                                }
                                .frame(width: 100, height: 30)
                                .padding(.horizontal, 15)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .frame(width: 300, height: 80)
                .cornerRadius(10)
                .padding()
            }
        }
    }
}

struct PostButton: View {
    @Binding var isLoading: Bool
    @Binding var postCreatedSuccessfully: Bool
    let selectedImage: UIImage?
    let caption: String
    let selectedCategory: String
    
    var body: some View {
        Button {
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
                .frame(width: 120, height: 30)
                .padding()
                .padding(.horizontal)
                .background(Color("Color"))
                .cornerRadius(30)
                .shadow(radius: 10)
        }
        .disabled(isLoading || selectedImage == nil)
    }
}
