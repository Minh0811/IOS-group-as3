//
//  ProfileUserView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

import SwiftUI
import Firebase
struct ProfileUserView: View {
    @ObservedObject var profileUser: ProfileUser
    @State private var showEditProfile = false

    init(profileUser: ProfileUser) {
        self.profileUser = profileUser
    }

    var body: some View {
        VStack {
            HStack{
                Image("Login")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                if let user = profileUser.chatUser {
                    Text("\(user.fname)")
                    Text("\(user.lname)")
                    // Add more fields as needed
                } else {
                    Text("Loading user data...")
                }
            }
            Text("Caption: Miss u forever")
            Button(action: {
                showEditProfile.toggle()
            }) {
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 32)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .fullScreenCover(isPresented: $showEditProfile) {
                EditProfileView()
            }
            Spacer()
        }
        .onAppear {
            // Fetch the current user's data when the view appears
            profileUser.fetchCurrentUser()
        }
    }
}

struct ProfileUserView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserView(profileUser: ProfileUser())
    }
}
