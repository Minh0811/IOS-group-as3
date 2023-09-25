/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 13/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI
@available(iOS 15.0, *)
struct RegisterView: View {
    @Environment(\.presentationMode) private var presentationMode:
    Binding<PresentationMode>
    @State private var isRegistrationSuccessful: Bool = false

    @State private var errorMessage: String?
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: LoginViewModel

        init(appState: AppState) {
            _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
        }

    var body: some View {
        ZStack {
            Image("theme")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Spacer()
                VStack(alignment: .leading){
                    Text("Registation")
                        .font(Font.custom("Baskerville-Bold", size: 45))
                        .foregroundColor(Color("Color"))
                        .fontWeight(.bold)
                    Text("Create an Account")
                        .font(Font.custom("Times New Roman", size: 20))
                        .foregroundColor(Color("Color"))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                }
                
                
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
                HStack{
                    SecureField("Password", text: $viewModel.password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.subheadline)
                    
                    Image(systemName: "eye.slash")
                        .padding(.horizontal)
                }.padding(12)
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
                        .font(Font.custom("Baskerville-Bold", size: 20))
                        .foregroundColor(Color("Color 2"))
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
                Spacer()
            }
            .navigationBarTitle("Register", displayMode: .inline)
        }
        .customBackButton(presentationMode: presentationMode)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var mockAppState = AppState()  // Create a mock instance of AppState

    static var previews: some View {
        RegisterView(appState: mockAppState)
    }
}

