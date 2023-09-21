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
        .environment(\.colorScheme, .light)
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



struct AppBarView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image("menu")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10.0)
            }
            Spacer()
            
            Button(action: {}) {
                Image(uiImage: #imageLiteral(resourceName: "Profile"))
                    .resizable()
                    .frame(width: 42, height: 42)
                    .cornerRadius(10.0)
            }
        }
        .padding(.horizontal)
    }
}

struct TagLineView: View {
    var body: some View {
        Text("Welcome to Home Page! ")
            .font(.custom("PlayfairDisplay-Regular", size: 28))
            .foregroundColor(Color("Primary"))
          
    }
}

//struct SearchAndScanView: View {
//    @Binding var search: String
//    var body: some View {
//        HStack {
//            HStack {
//                Image("Search")
//                    .padding(.trailing, 8)
//                TextField("Search Furniture", text: $search)
//            }
//            .padding(.all, 10)
//            .background(Color.white)
//            .cornerRadius(10.0)
//            .padding(.trailing, 8)
//            
//            Button(action: {}) {
//                Image("Search")
//                    .padding(.all, 13)
//                    .background(Color("Primary"))
//                    .cornerRadius(10.0)
//            }
//        }
//        .padding(.horizontal)
//    }
//}

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






