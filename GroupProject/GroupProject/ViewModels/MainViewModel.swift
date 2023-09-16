//
//  MainViewModel.swift
//  GroupProject
//
//  Created by Minh Vo on 13/09/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class MainViewModel: ObservableObject {
    @Published var chatUser: User?
    @Published var errorMessage: String = ""
    private var userService: UserService

    init(userService: UserService = UserService()) {
        self.userService = userService
        fetchCurrentUser()
    }

    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
                    self.errorMessage = "Could not find firebase uid"
                    return
                }
        userService.fetchCurrentUser()
    }

//    func logOut() {
//        userService.logOut { [weak self] result in
//            switch result {
//            case .success: break
//                // Handle successful logout, e.g., navigate to login screen
//            case .failure(let error):
//                self?.errorMessage = "Failed to log out: \(error.localizedDescription)"
//            }
//        }
//    }
}

