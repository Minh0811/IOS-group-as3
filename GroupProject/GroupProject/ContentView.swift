//
//  ContentView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isUserCurrentlyLoggedOut: Bool = false
    var body: some View {
        NavigationView {
            if self.isUserCurrentlyLoggedOut{
                MainView(isUserCurrentlyLoggedOut: $isUserCurrentlyLoggedOut)
            } else{
                LoginView(isUserCurrentlyLoggedOut: $isUserCurrentlyLoggedOut)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
