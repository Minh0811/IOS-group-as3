/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Tran Huy Khanh
  ID: 3804620
  Created  date: 17/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    @Published var users: [User] = [] // Store the list of users
    
    init() {
        fetchAllUsers()
    }
    func fetchAllUsers() {
        UserService.fetchAllUsers { [weak self]result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self?.users = users
                }
            case .failure(let error):
                // Handle the error appropriately
                print("Error fetching users:", error)
            }
        }
    }
    
    func fetchUsers() {
        Task {
            do {
                let fetchedUsers = try await UserService().fetchUsers()
                DispatchQueue.main.async {
                    self.users = fetchedUsers
                }
            } catch {
                // Handle error
                print(error.localizedDescription)
            }
        }
    }
}



