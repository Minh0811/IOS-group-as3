//
//  Post.swift
//  GroupProject
//
//  Created by Kiet Tran Tuan on 15/09/2023.
//

import Foundation

struct Post: Identifiable, Codable, Equatable {
    var id: String
    var userId: String  // User ID of the post creator
    var username: String  // Username of the post creator
    var imageUrl: String  // URL of the image associated with the post
    var caption: String  // Caption or status of the post
    var like: [String]
    var commentsCount: Int = 0
}

extension Post {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id // Assuming `id` uniquely identifies a Post
    }
}
