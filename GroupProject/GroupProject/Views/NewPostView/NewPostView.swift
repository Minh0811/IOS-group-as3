//
//  NewPostView.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import SwiftUI
import CoreLocation

struct NewPostView: View {
    @State private var selectedImage: UIImage?
    @State private var caption: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var isLoading: Bool = false
    @State private var postCreatedSuccessfully: Bool = false
    @State var isSheetPresented : Bool = false
    @State var location : LocationItem = LocationItem(imageUrl:"test-image", name: "", coordinate: CLLocationCoordinate2D(latitude: 0,longitude: 0))
    
    @State private var selectedCategory: String = "All"
    let categories = ["All", "Coffee", "Foods", "Schools", "Street Foods", "Beauty"]
    @EnvironmentObject var globalSettings: GlobalSettings
    
    @State private var isDropdownVisible = false
    
    
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
                    VStack {
                        Image("img")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding(.top)
                        Text("Choose your image")
                            .fontWeight(.semibold)
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding([.leading, .bottom, .trailing])
                    }
                }
                //                .padding(.horizontal)
                //                Rectangle()
                //                    .stroke(Color.white, lineWidth: 4)
                //                    .frame(width: 100, height: 80)
                .background()
                .opacity(1)
                .cornerRadius(30)
                
            }
            
            Spacer()
            TextField("Enter caption", text: $caption, axis: .vertical)
                .padding(.horizontal)
                .frame(width: 350, height: 90)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
            if location.name == ""{
                Button(action:{ isSheetPresented=true
                })
                {
                    Text("picker")
                        .padding()
                    
                        .cornerRadius(8)
                }
            }else{
                Button(action:{ isSheetPresented=true
                })
                {
                    Text(location.name).padding()
                        .cornerRadius(8)
                        .cornerRadius(8)
                }
                
            }
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
                List(categories, id: \.self) { category in
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
                }
                .frame(width: 280, height: 100)
                .cornerRadius(8)
                
            }
            
            Button(action: {
                Task {
                    isLoading = true
                    do {
                        let success = try await PostService().createPost(image: selectedImage!, caption: caption, category: selectedCategory, name: location.name, location: Coordinates    (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                        
                        postCreatedSuccessfully = success
                    } catch {
                        // Handle error
                        print(error.localizedDescription)
                    }
                    isLoading = false
                }
            }) {
                Text("Post")
                    .font(Font.custom("Baskerville-Bold", size: 24))
                    .foregroundColor(.black)
                    .padding()
                    .padding(.horizontal)
                    .background(Color("Color"))
                    .cornerRadius(30)
                    .shadow(radius: 10)
            }
            .disabled(isLoading || selectedImage == nil)
            Spacer()
        }
        .background(Image("theme"))
        
        .sheet(isPresented: $isImagePickerPresented) {
            NewPostImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $isSheetPresented){
            SearchView(isSheetPresented: $isSheetPresented, location: $location )
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
