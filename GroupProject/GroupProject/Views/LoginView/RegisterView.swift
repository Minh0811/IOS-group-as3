//
//  RegisterView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 13/09/2023.
//

import SwiftUI
@available(iOS 15.0, *)
struct RegisterView: View {
  
    @State private var isRegistrationSuccessful: Bool = false
    @State private var errorMessage: String?
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: LoginViewModel

        init(appState: AppState) {
            _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
        }

    var body: some View {
        VStack(spacing: 20) {
            Text("Create an Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            TextField("User Name:", text: $viewModel.username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.subheadline)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
           
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.subheadline)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.subheadline)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
            Button {
                viewModel.createNewAccount { success in
                        if success {
                            // Registration succeeded
                            isRegistrationSuccessful = true
                            errorMessage = nil
                        } else {
                            // Registration failed, display the error message
                            isRegistrationSuccessful = false
                            errorMessage = viewModel.errorMessage
                        }
                    }
            } label: {
                
                    Spacer()
                    Text("Create Account")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(.systemGreen))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGreen), lineWidth: 1)
                        )
                
            }
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 8)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5))
            } else if isRegistrationSuccessful {
                Text("Registration Successful")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.top, 8)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5))
            }
        }
        .padding()
        .navigationBarTitle("Register", displayMode: .inline)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var mockAppState = AppState()  // Create a mock instance of AppState

    static var previews: some View {
        RegisterView(appState: mockAppState)
    }
}

