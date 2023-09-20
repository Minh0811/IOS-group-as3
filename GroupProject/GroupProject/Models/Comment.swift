//
//  Comment.swift
//  GroupProject
//
//  Created by Minh Vo on 20/09/2023.
//

import SwiftUI

struct Comment: Identifiable, Codable {
    var id: String
    var postId: String  // This associates the comment with a specific post
    var userId: String
    var username: String
    var text: String
    var timestamp: Date
}

