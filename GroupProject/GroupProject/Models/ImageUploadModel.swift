//
//  ImageUploadModel.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 12/09/2023.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage
import PhotosUI
class ImageUploadModel: ObservableObject {
    @Published var uploadedImageUrl: String?
    @Published var uploadError: String?

    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            uploadError = "Failed to convert image to data"
            return
        }

        let storageRef = Storage.storage().reference().child("images").child("\(UUID().uuidString).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error)")
                self.uploadError = "Failed to upload image"
                return
            }

            storageRef.downloadURL { (url, error) in
                if let imageUrl = url?.absoluteString {
                    self.uploadedImageUrl = imageUrl
                } else {
                    self.uploadError = "Failed to get image URL"
                }
            }
        }
    }
}
