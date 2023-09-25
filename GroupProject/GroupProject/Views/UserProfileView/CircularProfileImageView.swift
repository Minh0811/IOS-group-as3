//
//  CircularProfileImageView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 16/09/2023.
//

import SwiftUI
import Kingfisher
enum ProfileImageSize{
    case xSmall
    case small
    case medium
    case large
    var dimension: CGFloat {
        switch self {
        case .xSmall:
            return 40
        case .small:
            return 48
        case .medium:
            return 64
        case .large:
            return 80
        }
    }
}
struct CircularProfileImageView: View {
    let user: User
    let size: ProfileImageSize
    let scalingFactor: CGFloat
    var body: some View {
        if let imageUrl = user.profileImageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 50 * scalingFactor, height: 50 * scalingFactor)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("Color"),lineWidth: 3))
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 50 * scalingFactor, height: 50 * scalingFactor)
                .clipShape(Circle())
                .foregroundColor(Color(.systemGray))
        }
    }
}


