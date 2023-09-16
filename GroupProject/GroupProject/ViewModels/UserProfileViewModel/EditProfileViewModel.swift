//
//  ImageUploadModelView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 16/09/2023.
//

import Foundation
import Firebase
import SwiftUI
import PhotosUI
import FirebaseStorage
@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var userService: UserService
    @Published var user: User
    
    init(user: User, userService: UserService = UserService()) {
        self.user = user
        self.userService = userService
        self.user = User(id: "", username: "", email: "", profileImageUrl: "", fullname: "", bio: "")
        
        if let fullname = user.fullname{
            self.fullname = fullname
        }
        if let bio = user.bio {
            self.bio = bio
        }
    }
    init() {
            self.userService = UserService()
            self.user = User(id: "", username: "", email: "", profileImageUrl: "", fullname: "", bio: "")
        }
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    

    @Published var profileImage: Image?
    @Published var fullname = ""
    @Published var bio = ""
    private var uiImage: UIImage?
   
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self) else { return  }
            guard let uiImage = UIImage(data: data) else { return }
            self.uiImage = uiImage
            self.profileImage = Image(uiImage: uiImage)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
    
    func updateUserData() async throws {
        var data = [String: Any]()
        if let uiImage = uiImage {
            do {
                let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
                data["profileImageUrl"] = imageUrl
            } catch {
                // Handle any errors that may occur during image upload
                print("Error uploading image: \(error.localizedDescription)")
                throw error
            }
        }
        
        if !fullname.isEmpty && user.fullname != fullname {
            data["fullname"] = fullname
           
            print("Update fullname: \(fullname)")
        }
        
        if !bio.isEmpty && user.bio != bio {
            data["bio"] = bio
           
            print("Update bio: \(bio)")
        }
//        if !data.isEmpty {
//            try await Firestore.firestore().collection("users").document(user.id).updateData(data)
//        }
        // Now, you can update the user's profile data using the `data` dictionary.
        do {
            try await userService.updateUserProfileData(data: data)
        } catch {
            // Handle any errors that may occur during the data update
            print("Error updating user data: \(error.localizedDescription)")
            throw error
        }
        
        
    }


}
