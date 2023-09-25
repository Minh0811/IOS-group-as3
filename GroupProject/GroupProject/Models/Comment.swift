/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Vo Khai Minh
  ID: 3879953
  Created  date: 20/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/

import SwiftUI

struct Comment: Identifiable, Codable, Hashable {
    var id: String
    var postId: String  // This associates the comment with a specific post
    var userId: String
    var username: String
    var text: String
    var timestamp: Date
}

