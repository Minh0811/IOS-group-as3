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
    @State private var shouldShowLoginAlert: Bool = false
    var body: some View {
            VStack(spacing: 20) {
                Spacer()
                Image("Login")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                
                Button(action: {
                    viewModel.loginUser { success in
                        if success{
                            isLoginSuccessful = true
                            
                        }
                        else {shouldShowLoginAlert = true}
                    }
                }) {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                }.padding(.vertical)
                .background(
                    NavigationLink("", destination: HomeView(), isActive: $isLoginSuccessful)
                ).alert(isPresented: $shouldShowLoginAlert) {
                    Alert(title: Text("Email/Password incorrect"))
                }
                HStack{
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                        .foregroundColor(.gray)
                    Text("OR")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                        .foregroundColor(.gray)
                    
                }
                NavigationLink(destination: RegisterView()){
                    Text("Create Account")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemGreen))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
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
