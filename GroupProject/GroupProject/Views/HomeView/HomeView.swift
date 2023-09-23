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
        
        VStack{
                NavigationView {
                    ZStack {
                       
                        Color("Background")
                            .ignoresSafeArea()
                        
                        ScrollView (showsIndicators: false) {
                            VStack (alignment: .leading) {                     
                                // Menu and profile picture
                                //AppBarView()
                                // Title
                                TagLineView()
                                    .padding()
                                //Sreach Bar
                                //SearchAndScanView(search: $search)
                                
                                
                                //Post tags
                  
                                
                                
                                PostView()
                                
                                
                                
                            }
                        }
                        

                        
                        
                    }
                    
                }
                //        .navigationBarTitle("") //this must be empty
                //        .navigationBarHidden(true)
                //        .navigationBarBackButtonHidden(true)
                
            
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
        .background(globalSettings.isDark ? Color.black : Color.white)
        
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            
    }
}




struct TagLineView: View {
    var body: some View {
        Text("Welcome to Home Page! ")
            .font(.custom("PlayfairDisplay-Regular", size: 28))
            .foregroundColor(Color("Primary"))
          
    }
}


struct CategoryView: View {
    let isActive: Bool
    let text: String
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text(text)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(isActive ? Color("Primary") : Color.black.opacity(0.5))
            if (isActive) { Color("Primary")
                .frame(width: 15, height: 2)
                .clipShape(Capsule())
            }
        }
        .padding(.trailing)
    }
}






