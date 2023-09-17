//
//  AppState.swift
//  GroupProject
//
//  Created by Minh Vo on 17/09/2023.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    var navigationCoordinator = NavigationCoordinator()

        func resetNavigation() {
            navigationCoordinator.selection = nil
        }
}
