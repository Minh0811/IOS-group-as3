//
//  RegisterView.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 12/09/2023.
//

import SwiftUI
import Firebase
struct RegisterView: View {
    @State var email = ""
    @State var password = ""
    @State var fname = ""
    @State var lname = ""
    @State var StatusMessage = ""
    @Binding var isUserCurrentlyLoggedOut : Bool
    @State private var shouldShowLoginAlert: Bool = false
    @State private var isRegistrationSuccessful: Bool = false
    var body: some View {
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
                Image(systemName: isRegistrationSuccessful ? "checkmark" : "person.fill")
                                .font(.system(size: 20))
                                .padding()
                                .foregroundColor(isRegistrationSuccessful ? .white : Color(.label))
            }.background(Color.green)

        }.cornerRadius(10)
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
                isRegistrationSuccessful = false
                return
            }
             
            print("Successfully created user")

            self.StatusMessage = "Successfully created user"
            isRegistrationSuccessful = true
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isUserCurrentlyLoggedOut: .constant(true))
    }
}
