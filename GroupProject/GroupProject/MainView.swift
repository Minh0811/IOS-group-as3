//
//  MainView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct MainView: View {
    @State var shouldShowLogOutOptions = false
     
    @ObservedObject private var vm = ProfileUser()
    @State private var isProfileViewActive = false
    @Binding var isUserCurrentlyLoggedOut : Bool
     
    @State var index = 0
     
    var body: some View {
        NavigationView{
            VStack(spacing: 40) {
                customNavBar
                    .padding()
               HomeView()
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .animation(.spring())
    }
     
    private var customNavBar: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: ProfileUserView(profileUser: vm)) {
                                WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                    )
                                    .shadow(radius: 5)
                            }
             
            HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                 
            
             
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    try? Auth.auth().signOut()
                    self.isUserCurrentlyLoggedOut = false
                }),
                    .cancel()
            ])
        }
    }
}
 
struct MainView_Previews: PreviewProvider {
    @State static var isUserCurrentlyLoggedOut = false
    static var previews: some View {
        MainView(isUserCurrentlyLoggedOut: $isUserCurrentlyLoggedOut)
    }
}
