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
