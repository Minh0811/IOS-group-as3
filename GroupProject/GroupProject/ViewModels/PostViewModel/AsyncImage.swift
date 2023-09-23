//
//  AsyncImage.swift
//  GroupProject
//
//  Created by Minh Vo on 18/09/2023.
//

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

