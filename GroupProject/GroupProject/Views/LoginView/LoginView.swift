//
//  LoginView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: LoginViewModel
    @State private var isLoginSuccessful = false
    @State private var shouldShowLoginAlert: Bool = false
       init(appState: AppState) {
           _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
           
       }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Logo
            Image("Login")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
            
            // Email Field
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .font(.subheadline)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            // Password Field
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
                .font(.subheadline)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            // Login Button
            Button(action: {
                viewModel.loginUser { success in
                    if success {
                        appState.isUserLoggedIn = true
                        isLoginSuccessful = true
                    } else {
                        shouldShowLoginAlert = true
                    }
                }
            }) {
                Text("Login")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 44)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.vertical)
            .background(
                NavigationLink("", destination: HomeView(), isActive: $isLoginSuccessful)
            ).alert(isPresented: $shouldShowLoginAlert) {
                Alert(title: Text("Email/Password incorrect"))
            }
            
            // OR Separator
            HStack {
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
            
            // Create Account Button
            NavigationLink(destination: RegisterView(appState: appState)) {
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
    static var mockAppState = AppState()
    static var previews: some View {
        LoginView(appState: mockAppState)
    }
}
