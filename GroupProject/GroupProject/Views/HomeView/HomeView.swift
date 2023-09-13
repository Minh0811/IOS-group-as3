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
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
