//
//  TabView.swift
//  GroupProject
//
//  Created by Minh Vo on 18/09/2023.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0

     var body: some View {
         TabView(selection: $selectedTab) {
             // HomeView
             HomeView()
                 .tabItem {
                     Image(systemName: "house.fill")
                     Text("Home")
                 }
                 .tag(0)

             // UserSearchView
             SearchUserView()
                 .tabItem {
                     Image(systemName: "magnifyingglass")
                     Text("Search")
                 }
                 .tag(1)

             // CreatePostView
             NewPostView()
                 .tabItem {
                     Image(systemName: "plus.square.fill")
                     Text("Create Post")
                 }
                 .tag(2)

             // UserProfileView
             CurrentUserProfileView()
                 .tabItem {
                     Image(systemName: "person.fill")
                     Text("Profile")
                 }
                 .tag(3)
         }
     }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
