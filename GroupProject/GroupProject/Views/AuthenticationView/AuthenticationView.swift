//
//  AuthenticationView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("selectedAppearance") private var selectedAppearance: String = "system"

    var body: some View {
        NavigationView {
            VStack {
                if appState.isUserLoggedIn {
                    TabBarView()
                } else {
                    LoginView(appState: appState)
                }
            }
            
            .preferredColorScheme(selectedAppearance == "dark" ? .dark : .light)
           
        }
        .navigationViewStyle(.stack)
    }
}



struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
