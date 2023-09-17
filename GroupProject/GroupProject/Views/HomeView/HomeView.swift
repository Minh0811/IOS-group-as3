//
//  HomeView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//



import SwiftUI

struct HomeView: View {
    
    @State private var search: String = ""
    @State private var selectedIndex: Int = 1
    
    private let categories = ["Coffee", "Foods", "Schools", "Street Foods", "Beauty", "etx..."]
    var body: some View {
        
        VStack{
                NavigationView {
                    ZStack {
                       
                        Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
                            .ignoresSafeArea()
                        
                        ScrollView (showsIndicators: false) {
                            VStack (alignment: .leading) {
                                NavigationLink(destination: CurrentUserProfileView()) {
                                    Text("User Profile")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .frame(width: 360, height: 44)
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                NavigationLink(destination: SearchUserView()) {
                                    Text("Search User")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .frame(width: 360, height: 44)
                                        .background(Color(.systemBlue))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                // Menu and profile picture
                                AppBarView()
                                // Title
                                TagLineView()
                                    .padding()
                                //Sreach Bar
                                SearchAndScanView(search: $search)
                                
                                
                                //Post tags
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(0 ..< categories.count) { i in
                                            Button(action: {selectedIndex = i}) {
                                                CategoryView(isActive: selectedIndex == i, text: categories[i])
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                
                                
                                PostView()
                                
                                
                                
                            }
                        }
                        
                        VStack {
                            Spacer()
                            
                            // BottomNavBarView()
                        }
                        
                        
                    }
                }
                //        .navigationBarTitle("") //this must be empty
                //        .navigationBarHidden(true)
                //        .navigationBarBackButtonHidden(true)
                
            
        }
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

struct SearchAndScanView: View {
    @Binding var search: String
    var body: some View {
        HStack {
            HStack {
                Image("Search")
                    .padding(.trailing, 8)
                TextField("Search Furniture", text: $search)
            }
            .padding(.all, 10)
            .background(Color.white)
            .cornerRadius(10.0)
            .padding(.trailing, 8)
            
            Button(action: {}) {
                Image("Search")
                    .padding(.all, 13)
                    .background(Color("Primary"))
                    .cornerRadius(10.0)
            }
        }
        .padding(.horizontal)
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

//struct BottomNavBarView: View {
//    var body: some View {
//        HStack {
//            BottomNavBarItem(image: Image("Home"), action: {})
//            BottomNavBarItem(image: Image("Home"), action: {})
//            BottomNavBarItem(image: Image("Home"), action: {})
//            BottomNavBarItem(image: Image("User"), action: {})
//        }
//        .padding()
//        .background(Color.white)
//        .clipShape(Capsule())
//        .padding(.horizontal)
//        .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 2, y: 6)
//    }
//}

struct BottomNavBarItem: View {
    let image: Image
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            image
                .frame(maxWidth: .infinity)
        }
    }
}




