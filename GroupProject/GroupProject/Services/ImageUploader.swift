/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 16/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import Foundation
import UIKit
import Firebase
import FirebaseStorage

struct ImageUploader {

    
    static func uploadImage(image: UIImage) async throws -> String? {
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return nil }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        do {
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("\(error.localizedDescription)")
            return nil
        }
    }
}
