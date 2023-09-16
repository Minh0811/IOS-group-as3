//
//  PostView.swift
//  GroupProject
//
//  Created by Minh Vo on 16/09/2023.
//

import SwiftUI

struct PostView: View {
    
    @State private var search: String = ""
    @State private var selectedIndex: Int = 1
    private var categories = ["Coffee", "Foods", "Schools", "Street Foods", "Beauty", "etx..."]
    var body: some View {

       
        //Posts
        ScrollView ( showsIndicators: false) {
            HStack{
                Spacer()
                VStack (spacing: 20) {
                    ForEach(0 ..< 4) { i in
                        NavigationLink(
                            destination: DetailView(),
                            label: {
                                CardView(image: Image("chair_\(i+1)"), size: 320)
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

struct CardView: View {
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

struct PostView_Previews: PreviewProvider {
  
    static var previews: some View {
        ZStack{
            Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
                .ignoresSafeArea()
            PostView()
        }
    }
}
