//
//  HomeView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//



import SwiftUI

struct HomeView: View {
    
    @ObservedObject var userService = UserService()
    @State private var search: String = ""
    @EnvironmentObject var globalSettings: GlobalSettings
    
    
    var body: some View {
        ZStack{
            globalSettings.isDark ? Color("DarkBackground").ignoresSafeArea() :  Color("LightBackground").ignoresSafeArea()
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading) {
                    HStack{
                        Spacer()
                        Text("Welcome to Home Page! ")
                            .font(.custom("PlayfairDisplay-Regular", size: 28))
                            .foregroundColor(globalSettings.isDark ? Color("LightBackground") :  Color("PrimaryText"))
                            .padding()
                        Spacer()
                    }
                    PostView()
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        
    }
}










