//
//  SearchViewModel.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 17/09/2023.
//
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



