//
//  PostEditView.swift
//  GroupProject
//
//  Created by Kiet Tran Tuan on 15/09/2023.
//

import SwiftUI

struct PostEditView: View {
    
    @State var status: String = ""
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack (spacing: 0){
                    HStack (spacing: 0){
                        
                        //use's profile image
                        Image("user")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.gray),lineWidth: 3))
                
                        VStack(spacing: 0) {
                            //username
                            Text("Username")
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                            //uploaded date of status
                            Text("15 Sep, 2023")
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                        }
                        
                                                
                        Spacer()
                            .frame(width: geometry.size.width * 0.5)
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.04)
                    //edit text field
                    VStack(spacing: 0) {
                        TextField("Write something ...", text: $status, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: geometry.size.width * 0.87)
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.width * 0.08)
                    //status's image
                    Image("testing-image")
                        .resizable()
                    
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
}

struct PostEditView_Previews: PreviewProvider {
    static var previews: some View {
        PostEditView()
    }
}
