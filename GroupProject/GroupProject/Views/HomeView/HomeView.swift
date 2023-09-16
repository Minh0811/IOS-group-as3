//
//  HomeView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack{
            Text("Hello, Home!")
            NavigationLink(destination: UserProfileView()){
                Text("User Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 44)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
