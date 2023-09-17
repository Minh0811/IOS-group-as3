//
//  LoginViewModel.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    private var userService: UserService
    var appState: AppState
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var showingError: Bool = false

    init(userService: UserService = UserService(), appState: AppState) {
        self.userService = userService
        self.appState = appState
    }
    

    func loginUser(completion: @escaping (Bool) -> Void) {
        userService.loginUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.appState.isUserLoggedIn = true
                completion(true)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.showingError = true
                completion(false)
            }
        }
    }
    // Use userService to create a new account
    func createNewAccount(completion: @escaping (Bool) -> Void) {
        userService.createNewAccount(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.loginUser{ success in
                    completion(success)
                    
                }  // After creating an account, attempt to log the user in
            case .failure(let error):
                self?.errorMessage = "Failed to create user: \(error.localizedDescription)"
                completion(false)
            }
        }
    }
}

