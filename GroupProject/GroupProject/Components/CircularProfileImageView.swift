//
//  CircularProfileImageView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 16/09/2023.
//

import SwiftUI
import Kingfisher
struct CircularProfileImageView: View {
    let profileImageUrl: User
    var body: some View {
        if let imageUrl = profileImageUrl.profileImageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .foregroundColor(Color(.systemGray))
        }
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(profileImageUrl: User.MOCK_USERS[0])
    }
}
