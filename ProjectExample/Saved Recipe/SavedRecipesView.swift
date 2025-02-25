//
//  SavedRecipesView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 03/01/25.

import SwiftUI
import SwiftData

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Query private var recipes: [Recipe]
    
    var title: String? = "Saved Recipes"
    var filteredrecipieCategory: Int = -1
    
    @State private var selectedRecipeId: UUID?
    @State private var showUpdateSheet = false
    
    private var filteredRecipes: [Recipe] {
        if filteredrecipieCategory == -1 {
            return recipes.filter { $0.isBookMarked }
        } else {
            return recipes.filter { $0.category == filteredrecipieCategory }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title ?? "")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primary)
                
                Spacer()
                
                if filteredrecipieCategory != -1 {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                            .foregroundColor(Color.accentColor)
                            .cornerRadius(10)
                            .shadow(color: colorScheme == .dark ? .black.opacity(0.2) : .gray.opacity(0.2),
                                    radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.bottom, 8)
            
            ScrollView {
                VStack {
                    if filteredRecipes.isEmpty {
                        VStack {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                            
                            Text("No saved recipes found")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                    } else {
                        ForEach(filteredRecipes, id: \.id) { recipe in
                            SavedRecipesCellView(
                                recipie: recipe,
                                onUpdate: {
                                    selectedRecipeId = recipe.id
                                    showUpdateSheet = true
                                }
                            )
                            .contentShape(Rectangle())
                            .zIndex(selectedRecipeId == recipe.id ? 1 : 0)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .fullScreenCover(isPresented: $showUpdateSheet) {
            if let recipeId = selectedRecipeId,
               let recipeToUpdate = recipes.first(where: { $0.id == recipeId }) {
                CreateRecipeView(recipe: recipeToUpdate)
            }
        }
        .onChange(of: showUpdateSheet) { newValue in
            if !newValue {
                selectedRecipeId = nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        SavedRecipesView()
            .modelContainer(for: Recipe.self, inMemory: true)
    }
}
