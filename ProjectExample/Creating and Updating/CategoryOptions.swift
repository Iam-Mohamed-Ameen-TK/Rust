//
//  CategoryOptions.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 06/02/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: String
    let isSelected: Bool
    let isHovered: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 12) {
                Image(systemName: categoryIcon)
                    .font(.system(size: 18))
                Text(category)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.red : Color(uiColor: .secondarySystemBackground))
                    .shadow(color: isSelected ? Color.accentColor.opacity(0.3) : .clear,
                           radius: isSelected ? 8 : 0)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .foregroundColor(isSelected ? .white : .primary)
            
            if isHovered {
                Text("View \(category) Recipes")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(6)
                    .offset(y: -30)
                    .transition(.opacity)
            }
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case "Breakfast": return "sun.and.horizon"
        case "Lunch": return "sun.max.fill"
        case "Dinner": return "moon.stars.fill"
        default: return "questionmark.circle"
        }
    }
}

struct RecipeDataView<Content: View>: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(uiColor: .tertiarySystemBackground))
                        .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            content()
                .padding(.horizontal, 4)
            
            if !value.isEmpty {
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading, 56)
            }
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}
