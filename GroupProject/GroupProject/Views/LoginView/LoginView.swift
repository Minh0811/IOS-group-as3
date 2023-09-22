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

       init(appState: AppState) {
           _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
           
       }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            
            VStack(alignment: .leading){
                Text("Sign in")
                    .font(Font.custom("Baskerville-Bold", size: 45))
                    .foregroundColor(Color("Color"))
                    .fontWeight(.bold)
            }
           
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
                    }
                }
            }) {
                Text("Login")
                    .font(Font.custom("Baskerville-Bold", size: 20))
                    .foregroundColor(Color("Color"))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color("Color 2"))
                    
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGreen), lineWidth: 1)
                    )
            }
            .padding(.vertical)
            .alert(isPresented: $viewModel.showingError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
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
                    .foregroundColor(Color("Color 2"))

                    .font(Font.custom("Baskerville-Bold", size: 20))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color("Color"))
                    
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGreen), lineWidth: 1)
                    )
            }
            
            
        }
        .background(Image("theme"))
        .padding()
    }
}



struct LoginView_Previews: PreviewProvider {
    static var mockAppState = AppState()
    static var previews: some View {
        LoginView(appState: mockAppState)
    }
}
