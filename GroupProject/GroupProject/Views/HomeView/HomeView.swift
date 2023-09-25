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
        ZStack {
            globalSettings.isDark ? Color("DarkBackground") .ignoresSafeArea() :  Color("LightBackground").ignoresSafeArea()
            GeometryReader { geometry in
                //  Calculate the ratio between current device and iphone 14
                var scalingFactor: CGFloat {
                    return geometry.size.width / globalSettings.iphone14ProBaseWidth
                }
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading) {
                        HStack{
                            Spacer()
                            //Text("\(geometry.size.width)")
                            Text("Welcome to Home Page! ")
                                .font(.custom("PlayfairDisplay-Regular", size: 30 * scalingFactor)).bold()
                                .foregroundColor(Color("PrimaryText"))
                            Spacer()
                        }
                        PostView(scalingFactor: scalingFactor)
                    }
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
        
        
    }
}

//        .navigationBarTitle("") //this must be empty
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        
    }
}








