//
//  ProfileUserView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

import SwiftUI

struct UserProfileView: View {
    //@ObservedObject var userService = UserService()
    let user: User
    //@State private var showEditProfile = false
    //@State private var refreshFlag = false
    //@State var user: User?
    @Environment (\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack {
                Image(user.profileImageUrl ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    if let fullname = user.fullname {
                        Text(fullname)
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    if let bio = user.bio {
                        Text(bio)
                            .font(.footnote)
                    }
                    // Add more user properties here as needed
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)


    
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: User.MOCK_USERS[0])
    }
}
