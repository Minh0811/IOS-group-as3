//
//  AuthenticationView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

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
