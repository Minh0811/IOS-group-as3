//
//  HomeView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 11/09/2023.
//

//
//  HomeScreen.swift
//  Furniture_app
//
//  Created by Abu Anwar MD Abdullah on 14/2/21.
//

import SwiftUI

struct HomeView: View {

    @State private var search: String = ""
    @State private var selectedIndex: Int = 1
    
    private let categories = ["Coffee", "Foods", "Schools", "Street Foods", "Beauty", "etx..."]
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
                    .ignoresSafeArea()
                
                ScrollView (showsIndicators: false) {
                    VStack (alignment: .leading) {
                        
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
                        
                        
                        //Posts
                        ScrollView ( showsIndicators: false) {
                            HStack{
                                Spacer()
                                VStack (spacing: 20) {
                                    ForEach(0 ..< 4) { i in
                                        NavigationLink(
                                            destination: DetailView(),
                                            label: {
                                                ProductCardView(image: Image("chair_\(i+1)"), size: 320)
                                            })
                                        .navigationBarHidden(true)
                                        .foregroundColor(.black)
                                    }
                                    //.padding(.leading)
                                }
                                Spacer()
                            }
                            
                        }
                        .padding(.bottom)
                        
                        
                        
                    }
                }
                
                VStack {
                    Spacer()
                    BottomNavBarView()
                }
            }
        }
        //        .navigationBarTitle("") //this must be empty
        //        .navigationBarHidden(true)
        //        .navigationBarBackButtonHidden(true)
        
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

struct ProductCardView: View {
    let image: Image
    let size: CGFloat
    
    var body: some View {
        VStack {
            image
                .resizable()
                .frame(width: size, height: 200 * (size/210))
                .cornerRadius(20.0)
            Text("Captions").font(.title3).fontWeight(.light)
            
            HStack (spacing: 2) {

                Text("User Name")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .frame(width: size)
        .padding()
        .background(Color.white)
        .cornerRadius(20.0)
        
    }
}


struct BottomNavBarView: View {
    var body: some View {
        HStack {
            BottomNavBarItem(image: Image("Home"), action: {})
            BottomNavBarItem(image: Image("Home"), action: {})
            BottomNavBarItem(image: Image("Home"), action: {})
            BottomNavBarItem(image: Image("User"), action: {})
        }
        .padding()
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.horizontal)
        .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 2, y: 6)
    }
}

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




