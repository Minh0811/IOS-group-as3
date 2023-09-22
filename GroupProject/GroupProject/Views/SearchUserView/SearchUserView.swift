//
//  SearchUserView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 17/09/2023.
//

import SwiftUI

struct SearchUserView: View {
    @State private var searchText = ""
    @ObservedObject var userService = UserService()
    @StateObject var viewModel = SearchViewModel()
    @EnvironmentObject var globalSettings: GlobalSettings
    // Filtered users based on search text
    var filteredUsers: [User] {
           if searchText.isEmpty {
               return viewModel.users
           } else {
               return viewModel.users.filter { user in
                   let usernameMatch = user.username.lowercased().contains(searchText.lowercased())
                    let bioMatch = user.bio?.lowercased().contains(searchText.lowercased()) ?? false
                                 return usernameMatch || bioMatch
               }
           }
       }
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 12){
                    ForEach(filteredUsers){ user in
                        NavigationLink(value: user){
                            HStack {
                                CircularProfileImageView(user: user, size: .small )
                                VStack(alignment: .leading){
                                    Text(user.username)
                                        .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                                        .fontWeight(.semibold)
                                    if let bio = user.bio {
                                        Text(bio)
                                            .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                                    }
                                }.font(.footnote)
                                
                                Spacer()
                            }
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        }
                        
                    }
                }
                .onAppear {
                    viewModel.fetchAllUsers()
                }
                
                .padding(.top, 8)
                .searchable(text: $searchText)
            }
            .background(globalSettings.isDark ? Color.black : Color.white)
            .navigationDestination(for: User.self, destination: {user in
                UserProfileView(user: user, currentUser: userService.currentUser ?? User(id: "N/A", username: "N/A", email: "N/A", fullname: "N/A", bio: "N/A", followers: [], following: []))
            })
            .navigationTitle("Search User")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}

