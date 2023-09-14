//
//  RegisterView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 13/09/2023.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var isLoginSuccessful = false
    var body: some View {
        VStack{
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            Button{
                viewModel.createNewAccount{ success in
                    if success{
                        isLoginSuccessful = true
                    }
                    
                }
            } label: {
                Text("Create Account")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        //.navigationBarBackButtonHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
