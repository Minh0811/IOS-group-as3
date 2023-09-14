//
//  MainView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State var shouldShowLogOutOptions = false
    @Binding var isUserCurrentlyLoggedOut: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                customNavBar.padding()
                HomeView()
            }
        }
        .navigationBarHidden(true)
        .animation(.spring())
    }

    private var customNavBar: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: UserProfileView()) {
                WebImage(url: URL(string: viewModel.chatUser?.profileImageUrl ?? ""))
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
//        .actionSheet(isPresented: $shouldShowLogOutOptions) {
//            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
//                .destructive(Text("Sign Out"), action: {
//                    $viewModel.logOut
//                }),
//                .cancel()
//            ])
//        }
    }
}

 
struct MainView_Previews: PreviewProvider {
    @State static var isUserCurrentlyLoggedOut = false
    static var previews: some View {
        MainView(isUserCurrentlyLoggedOut: $isUserCurrentlyLoggedOut)
    }
}
