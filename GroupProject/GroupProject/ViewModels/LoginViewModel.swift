//
//  LoginViewModel.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    private var userService: UserService
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isUserLoggedIn: Bool = false

    init(userService: UserService = UserService()) {
        self.userService = userService
    }

    // Use userService to login user
    func loginUser() {
        userService.loginUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.isUserLoggedIn = true
            case .failure(let error):
                self?.errorMessage = "Failed to login user: \(error.localizedDescription)"
            }
        }
    }

    // Use userService to create a new account
    func createNewAccount() {
        userService.createNewAccount(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.loginUser()  // After creating an account, attempt to log the user in
            case .failure(let error):
                self?.errorMessage = "Failed to create user: \(error.localizedDescription)"
            }
        }
    }
}
