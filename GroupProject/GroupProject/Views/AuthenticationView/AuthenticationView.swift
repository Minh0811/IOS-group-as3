/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 10/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var globalSettings = GlobalSettings.shared
    var body: some View {
        NavigationView {
            VStack {
                if appState.isUserLoggedIn {
                    TabBarView()
                        .environmentObject(globalSettings)
                } else {
                    LoginView(appState: appState)
                        .environmentObject(globalSettings)
                }
            }
           
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
