//
//  FullDetailSheet.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 06/02/25.
//

import SwiftUI

struct RecipeDetailSheet: View {
    let recipe: Recipe
    @Environment(\.dismiss) var dismiss
    @State private var isExpanded: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let data = recipe.photo, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                    } else {
                        Image(systemName: "photo.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .background(Color.gray.opacity(0.1))
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text(recipe.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Spacer()
                            HStack {
                                Image(systemName: "clock")
                                Text("\(recipe.time) min")
                            }
                            .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Details")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            if recipe.details.count > 300 && !isExpanded {
                                Text(recipe.details.prefix(300) + "...")
                                    .foregroundColor(.secondary)
                                Button(action: {
                                    isExpanded.toggle()
                                }) {
                                    Text("View More")
                                        .foregroundColor(.red)
                                }
                            } else {
                                Text(recipe.details)
                                    .foregroundColor(.secondary)
                                if recipe.details.count > 300 {
                                    Button(action: {
                                        isExpanded.toggle()
                                    }) {
                                        Text("View Less")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        
                        if !recipe.ingredients.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Ingredients")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 8))
                                            .foregroundColor(.gray)
                                        Text(ingredient)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}
