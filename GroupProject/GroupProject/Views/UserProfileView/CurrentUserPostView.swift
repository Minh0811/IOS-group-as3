//
//  CurrentUserPostView.swift
//  GroupProject
//
//  Created by Minh Vo on 19/09/2023.
//

import SwiftUI


struct CurrentUserPostView: View {
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: gridItems, spacing: 1) {
                ForEach(0 ... 5, id: \.self) { index in
                    Image("Login")
                        .resizable()
                        .scaledToFill()
                }
            }
        }
    }
}

struct CurrentUserPostView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserPostView()
    }
}
