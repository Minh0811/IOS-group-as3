/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Vo Khai Minh
  ID: 3879953
  Created  date: 17/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

class AppState: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    var navigationCoordinator = NavigationCoordinator()

        func resetNavigation() {
            navigationCoordinator.selection = nil
        }
}
