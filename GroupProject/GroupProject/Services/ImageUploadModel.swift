//
//  ImageUploadModel.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 12/09/2023.
//


import Firebase
import SwiftUI
import PhotosUI
import FirebaseStorage
@MainActor
class EditProfileViewModel: ObservableObject {
    
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
            let imageUrl = try? await ImageUploader.uploadImage(image: uiImage)
            data["profileImageUrl"] = imageUrl
        }
    }
}


