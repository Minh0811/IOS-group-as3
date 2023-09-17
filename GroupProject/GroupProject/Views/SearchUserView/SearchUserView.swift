//
//  SearchUserView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 17/09/2023.
//

import SwiftUI

struct SearchUserView: View {
    @State private var searchText = ""
    @StateObject var viewModel = SearchViewModel()
    // Filtered users based on search text
//    private var filteredUsers: [User] {
//           if searchText.isEmpty {
//               return User.viewModel.users
//           } else {
//               return User.MOCK_USERS.filter { user in
//                   return user.username.lowercased().contains(searchText.lowercased())
//               }
//           }
//       }
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 12){
                    ForEach(viewModel.users){ user in
                        NavigationLink(value: user){
                            HStack {
                                CircularProfileImageView(user: user )
                                VStack(alignment: .leading){
                                    Text(user.username)
                                        .fontWeight(.semibold)
                                    if let bio = user.bio {
                                        Text(bio)
                                    }
                                }.font(.footnote)
                                
                                Spacer()
                            }
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        }
                        
                    }
                }
                .padding(.top, 8)
                .searchable(text: $searchText)
            }
            .navigationDestination(for: User.self, destination: {user in
                UserProfileView(user: user)
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

