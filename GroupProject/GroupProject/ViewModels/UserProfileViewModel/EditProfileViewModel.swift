//
//  ImageUploadModelView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 16/09/2023.
//

import SwiftUI
import Firebase
import FirebaseStorage

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var userService: UserService
    @Published var user: User
    @Published var errorMessage: String?
    @Published var profileImage: Image?
    @Published var fullname: String
    @Published var bio: String
   var uiImage: UIImage?

    init(user: User, userService: UserService = UserService()) {
        self.user = user
        self.userService = userService
        self.fullname = user.fullname ?? ""
        self.bio = user.bio ?? ""
        loadImageFromURL(user.profileImageUrl)
    }

    
    func setImage(_ image: UIImage?) {
        self.uiImage = image
    }
    
    func loadImage(from uiImage: UIImage) {
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }

    func loadImageFromURL(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = uiImage
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }


    func updateUserData() async throws {
        var data = [String: Any]()
        
        if let uiImage = uiImage {
            do {
                let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
                data["profileImageUrl"] = imageUrl
            } catch {
                errorMessage = "Failed to upload image. Please try again."
                throw error
            }
        }

        if fullname != user.fullname {
            data["fullname"] = fullname
        }

        if bio != user.bio {
            data["bio"] = bio
        }

        do {
            try await userService.updateUserProfileData(data: data)
        } catch {
            errorMessage = "Error updating user data. Please try again."
            throw error
        }
    }
}
