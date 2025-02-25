//
//  Item.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//

import SwiftUI
import SwiftData

@Model
class Profile {
    var name: String
    var bio: String
    var imageData: Data?
    
    init(name: String = "", bio: String = "", imageData: Data? = nil) {
        self.name = name
        self.bio = bio
        self.imageData = imageData
    }
}
