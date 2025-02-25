//
//  Recipe.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//

import SwiftData
import SwiftUI

@Model
class Recipe: Identifiable, ObservableObject {
    var id: UUID = UUID()
    var title: String
    var details: String
    var time: Int
    var photo: Data? 
    var isBookMarked: Bool
    var isLiked: Bool = false
    var category: Int
    var ingredients: [String]
    init(
        id: UUID = UUID(),
        title: String,
        details: String,
        time: Int,
        photo: Data? = nil,
        isBookMarked: Bool = false,
        isLiked: Bool = false,
        category: Int,
        ingredients: [String] = []
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.time = time
        self.photo = photo
        self.isBookMarked = isBookMarked
        self.isLiked = isLiked
        self.category = category
        self.ingredients = ingredients
    }
}
