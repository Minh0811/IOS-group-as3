//
//  AuthenticationView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack {
                if appState.isUserLoggedIn {
                    HomeView()
                } else {
                    LoginView(appState: appState)
                }
            }
            .background(
                NavigationLink("", destination: CurrentUserProfileView(), tag: 1,
                               selection: $appState.navigationCoordinator.selection)
                    .hidden()
            )
        }
    }
}



struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
