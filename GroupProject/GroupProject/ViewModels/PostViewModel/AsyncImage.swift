/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Vo Khai Minh
  ID: 3879953
  Created  date: 18/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

struct AsyncImage: View {
    @State private var image: UIImage? = nil
    let url: String

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                // Placeholder until the image is loaded
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 350, height: 350)
                    .cornerRadius(10.0)
            }
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard let imageUrl = URL(string: url) else { return }

        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}

