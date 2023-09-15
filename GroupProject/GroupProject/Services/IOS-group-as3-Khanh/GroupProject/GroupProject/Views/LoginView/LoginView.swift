//
//  LoginView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @Binding var isUserCurrentlyLoggedOut : Bool
    @State private var isLoginSuccessful = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Button(action: {
                    viewModel.loginUser { success in
                        if success{
                            isLoginSuccessful = true
                        }
                        
                    }
                }) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .background(
                    NavigationLink("", destination: HomeView(), isActive: $isLoginSuccessful)
                )
                NavigationLink(destination: RegisterView()){
                    Text("Create Account")
                }
//                Button(action: {
//                    viewModel.createNewAccount()
//                }) {
//                    Text("Create New Account")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//
//                if !viewModel.errorMessage.isEmpty {
//                    Text(viewModel.errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                }
                
                Spacer()
            }
        }
        .padding()
    }
}

 
struct LoginView_Previews: PreviewProvider {
    @State static var isUserCurrentlyLoggedOut = false
    static var previews: some View {
        LoginView(isUserCurrentlyLoggedOut: $isUserCurrentlyLoggedOut)
    }
}
