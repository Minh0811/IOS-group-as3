//
//  CustomTabBarView.swift
//  GroupProject
//
//  Created by Minh Vo on 20/09/2023.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var tabSelection: Int
    @Namespace private var AnimcationNamespace
    
    let tabBarItems: [(image: String, title: String)] = [
    ("house.fill","Home"),
    ("magnifyingglass","Search"),
    ("plus.square.fill","Create Post"),
    ("person.fill","Profile"),
    ]
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: 60)
                .foregroundColor(Color("LightBackground"))
                //.shadow(radius: 2)
            HStack{
                ForEach(0..<4){ index in
                    Button {
                        tabSelection = index 
                    } label: {
                        VStack(spacing: 8){
                            Spacer()
                            Image(systemName: tabBarItems[index].image)
                            Text(tabBarItems[index].title)
                                .font(.caption)
                            
                            if index == tabSelection{
                                Rectangle()
                                    .frame(height: 8)
                                    .foregroundColor(.clear)
                                    .matchedGeometryEffect(id: "selectedTabId", in: AnimcationNamespace)
                                    .offset(y: 3)
                                    .cornerRadius(4)
                            } else {
                                Rectangle()
                                    .frame(height: 8)
                                    .foregroundColor(.clear)
                                    // .offset(y: 3)
                            }
                        }
                        .foregroundColor(index == tabSelection ? Color("PrimaryText") : Color("LightText"))
                    }
                }
                .frame(height: 80)
               
        }
        .padding(.horizontal)
        .clipShape(Capsule())
        }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView(tabSelection: .constant(1))
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
    }
}
