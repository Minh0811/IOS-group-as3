/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 17/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import Kingfisher

struct CurrentUserProfileView: View {
    @ObservedObject var userService = UserService()
    @ObservedObject var viewModel = PostViewModel()
    @EnvironmentObject var appState: AppState
    @State private var isLoggedOut: Bool = false
    @State var currentUser: User?
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var globalSettings: GlobalSettings
    
    
    var body: some View {
        
        ZStack {
            globalSettings.isDark ? Color("DarkBackground") .ignoresSafeArea() :  Color("LightBackground").ignoresSafeArea()
            GeometryReader { geometry in
                //  Calculate the ratio between current device and iphone 14
                var scalingFactor: CGFloat {
                    return geometry.size.width / globalSettings.iphone14ProBaseWidth
                }
                ScrollView {
                    ProfileDetail(scalingFactor: scalingFactor, currentUser: $currentUser)
                    
                    VStack {
                        NavigationLink(destination: EditProfileView(viewModel: EditProfileViewModel(user: currentUser ?? User(id: "", username: "", email: "", followers: [], following: []))).environmentObject(globalSettings)) {
                            Text("Edit Profile")
                                .font(Font.custom("Baskerville-Bold", size: 18 * scalingFactor))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 360 * scalingFactor, height: 32 *  scalingFactor)
                                .foregroundColor(globalSettings.isDark ? Color("LightText") :  Color("BlackText"))
                                .background(
                                    globalSettings.isDark ? Color("LightPost")  :  Color("DarkBackground")
                                )
                                .cornerRadius(15 * scalingFactor)
                        }
                        
                        
                        CurrentUserPostView(viewModel: viewModel, currentUser: currentUser ?? User(id: "", username: "", email: "", followers: [], following: []), scalingFactor: scalingFactor)
                        
                        Button(action: {
                            userService.logoutUser()
                            appState.isUserLoggedIn = false
                            appState.resetNavigation() // Reset the navigation
                        }) {
                            Text("Logout")
                                .font(Font.custom("Baskerville-Bold", size: 18 * scalingFactor))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 360 * scalingFactor, height: 44 * scalingFactor)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10 * scalingFactor)
                        }
                        .padding(.top)
                        // Perform an action when the button is tapped (optional)
                        
                        
                        
                    }
                    .onAppear {
                        userService.fetchCurrentUser { user in
                            self.currentUser = user
                            if let userId = user?.id {
                                viewModel.fetchUserPosts(userId: userId)
                            }
                        }
                    }
                    .onDisappear {
                        currentUser = nil
                    }
                    
                }
                //.background(globalSettings.isDark ? Color.black : Color.white)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarBackground(.hidden, for: .tabBar)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView()
            .environmentObject(GlobalSettings.shared)
    }
}

struct ProfileDetail: View {
    let scalingFactor: CGFloat
    @Binding var currentUser: User?
    @EnvironmentObject var globalSettings: GlobalSettings
    @ObservedObject var userService = UserService()
    var body: some View {
        if let user = currentUser {
            HStack{
                CircularProfileImageView(user: user, size: .large, scalingFactor: scalingFactor )
                Spacer()
                Text("Followers: \(user.followers.count)")
                    .font(Font.custom("", size: 18 * scalingFactor)).bold()
                    .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                Spacer()
                Text("Following: \(user.following.count)")
                    .font(Font.custom("", size: 18 * scalingFactor)).bold()
                    .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                Spacer()
                Button(action: {
                    userService.fetchCurrentUser { user in
                        self.currentUser = user
                    }
                }) {
                    Image(systemName: "gobackward")
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(user.username)")
                    .font(Font.custom("Baskerville-Bold", size: 23 * scalingFactor)).bold()
                    .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                Text("\(user.fullname ?? "N/A")")
                    .font(Font.custom("Baskerville-Bold", size: 12 * scalingFactor)).bold()
                    .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                Text("\(user.bio ?? "N/A")")
                    .font(Font.custom("Baskerville-Bold", size: 12 * scalingFactor))
                    .foregroundColor(globalSettings.isDark ? Color.white : Color.black)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        }
    }
}
