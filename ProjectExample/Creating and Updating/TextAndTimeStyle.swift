//
//  TextAndTimeStyle.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 06/02/25.
//

import SwiftUI

struct RecipeTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
    }
}

struct RecipeTimeFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(uiColor: .tertiarySystemBackground))
    }
    
}
