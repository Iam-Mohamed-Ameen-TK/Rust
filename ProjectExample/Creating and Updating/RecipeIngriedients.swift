//
//  RecipeIngriedients.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 06/02/25.
//

import SwiftUI

struct IngredientItem: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var amount: String
    
    init(name: String = "", amount: String = "") {
        self.name = name
        self.amount = amount
    }
    
    static func == (lhs: IngredientItem, rhs: IngredientItem) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.amount == rhs.amount
    }
}

struct RecipeTextFieldStyles: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

struct CreateRecipeIngredientsView: View {
    @Binding var ingredient: IngredientItem
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            TextField("Item name", text: $ingredient.name)
                .textFieldStyle(RecipeTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ingredient.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.red : Color.clear, lineWidth: 1)
                )
            
            TextField("Quantity", text: $ingredient.amount)
                .textFieldStyle(RecipeTextFieldStyle())
            
            Button(action: onDelete) {
                Image(systemName: "minus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
            }
        }
        .frame(height: 70)
    }
}
