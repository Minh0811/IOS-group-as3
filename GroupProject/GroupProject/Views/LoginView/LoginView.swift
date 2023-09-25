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
    @EnvironmentObject var globalSettings: GlobalSettings
       init(appState: AppState) {
           _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
           
       }
    
    var body: some View {
        ZStack{
            Image("theme")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                //  Calculate the ratio between current device and iphone 14
                var scalingFactor: CGFloat {
                    return geometry.size.width / globalSettings.iphone14ProBaseWidth
                }
                HStack{
                    Spacer()
                    VStack(spacing: 20) {
                        Spacer()
                        
                        
                        VStack(alignment: .leading){
                            Text("Sign in")
                                .font(Font.custom("Baskerville-Bold", size: 45 * scalingFactor))
                                .foregroundColor(Color("Color"))
                                .fontWeight(.bold)
                        }
                        
                        // Email Field
                        TextField("Email", text: $viewModel.email)
                            .frame(width: 250 * scalingFactor)
                            .autocapitalization(.none)
                            .font(.subheadline)
                            .padding(12  * scalingFactor)
                            .background(Color(.systemGray6))
                            .cornerRadius(10  * scalingFactor)
                            .padding(.horizontal, 24  * scalingFactor)
                        
                        // Password Field
                        SecureField("Password", text: $viewModel.password)
                            .frame(width: 250 * scalingFactor)
                            .autocapitalization(.none)
                            .font(.subheadline)
                            .padding(12  * scalingFactor)
                            .background(Color(.systemGray6))
                            .cornerRadius(10  * scalingFactor)
                            .padding(.horizontal, 24  * scalingFactor)
                        
                        // Login Button
                        Button(action: {
                            viewModel.loginUser { success in
                                if success {
                                    appState.isUserLoggedIn = true
                                }
                            }
                        }) {
                            Text("Login")
                                .font(Font.custom("Baskerville-Bold", size: 20  * scalingFactor))
                                .foregroundColor(Color("Color"))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44 * scalingFactor)
                                .frame(width: 200 * scalingFactor)
                                .background(Color("Color 2"))
                            
                                .cornerRadius(10  * scalingFactor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10  * scalingFactor)
                                        .stroke(Color(.systemGreen), lineWidth: 1  * scalingFactor)
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
                            
                                .font(Font.custom("Baskerville-Bold", size: 20  * scalingFactor))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44 * scalingFactor)
                                .frame(width: 200 * scalingFactor)
                                .background(Color("Color"))
                            
                                .cornerRadius(10  * scalingFactor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10  * scalingFactor)
                                        .stroke(Color(.systemGreen), lineWidth: 1  * scalingFactor)
                                )
                        }
                        
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var mockAppState = AppState()
    static var previews: some View {
        LoginView(appState: mockAppState)
    }
}
