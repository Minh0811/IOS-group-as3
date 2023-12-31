//
//  TabView.swift
//  GroupProject
//
//  Created by Minh Vo on 18/09/2023.
//

import SwiftUI
import CoreLocation

struct TabBarView: View {
    @State private var selectedTab: Int = 0

     var body: some View {
         TabView(selection: $selectedTab) {
             // HomeView
             HomeView()
                 .tag(0)

             // UserSearchView
             SearchUserView()
                 .tag(1)

             // CreatePostView
             NewPostView()
                 .tag(2)

             // UserProfileView
             CurrentUserProfileView()
                 .tag(3)
             MapView()
                 .tag(4)
             
         }
   
         .edgesIgnoringSafeArea(.bottom)
         
         .overlay(alignment: .bottom){
             CustomTabBarView(tabSelection: $selectedTab)
                 .padding(.horizontal)
                 .offset(y: 20)
         }
       
     }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
