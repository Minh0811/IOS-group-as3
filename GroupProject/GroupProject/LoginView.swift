//
//  LoginView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI
import Firebase
 
struct LoginView: View {
     
    @State var isLoginMode = false
        @State var email = ""
        @State var password = ""
        @State var fname = ""
        @State var lname = ""
         
        @State private var shouldShowLoginAlert: Bool = false
         
        @State var StatusMessage = ""
         
        @Binding var isUserCurrentlyLoggedOut : Bool
         
        var body: some View {
            ScrollView {
     
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                     
                    if !isLoginMode {
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                                .foregroundColor(Color(.label))
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64)
                                    .stroke(Color.black, lineWidth: 3)
                        )
                        Group {
                            TextField("First Name", text: $fname)
                            TextField("Last Name", text: $lname)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                         
                        Button {
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Create Account")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                            }.background(Color.green)
       
                        }.cornerRadius(10)
                    }else{
                        Image("Login")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(64)
                         
                        Group {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                         
                        Button {
                            loginUser()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Login")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                            }.background(Color.green)
       
                        }.cornerRadius(10)
                        .alert(isPresented: $shouldShowLoginAlert) {
                            Alert(title: Text("Email/Password incorrect"))
                        }
                    }
                     
                    Text(self.StatusMessage)
                        .foregroundColor(Color.white)
                     
                }.padding()
            } //End ScrollView
            .navigationViewStyle(StackNavigationViewStyle())
//            .background(
//                LinearGradient(gradient: Gradient(colors: [.white, .blue, .yellow]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//            )
        }
         
        private func loginUser() {
            Auth.auth().signIn(withEmail: email, password: password) { result, err in
                if err != nil {
                    print("Failed to login user")
                    self.StatusMessage = "Failed to login user"
                    self.shouldShowLoginAlert = true
                    return
                }
       
                print("Successfully logged in as user")
       
                self.StatusMessage = "Successfully logged in as user:"
     
                self.isUserCurrentlyLoggedOut = true
            }
        }
         
        private func handleAction() {
            createNewAccount()
        }
          
        private func createNewAccount() {
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if err != nil {
                    print("Failed to create user")
                    self.StatusMessage = "Failed to create user"
                    return
                }
                 
                print("Successfully created user")
       
                self.StatusMessage = "Successfully created user"
                 
                self.storeUserInformation()
                loginUser()
            }
        }
         
    private func storeUserInformation() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["fname": self.fname, "lname": self.lname, "email": self.email, "profileImageUrl": "profileurl", "uid": uid]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.StatusMessage = "\(err)"
                    return
                }
                
                print("Success")
            }
    }
}
 
struct LoginView_Previews: PreviewProvider {
    @State static var isUserCurrentlyLoggedOut = false
    static var previews: some View {
        LoginView(isUserCurrentlyLoggedOut: $isUserCurrentlyLoggedOut)
    }
}
