//
//  HomeView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var searchText: String = ""
    var recipes: [Recipe]
    @State private var showSheet: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var filteredrecipies: [Recipe] {
        guard !searchText.isEmpty else { return recipes }
        return recipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var groupedRecipes: [Int: [Recipe]] {
        Dictionary(grouping: filteredrecipies, by: { $0.category })
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                headerView
                searchBar
                recipeCategories
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Find best recipes for cooking")
                .font(.title)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search recipes", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var recipeCategories: some View {
        ScrollView {
            if filteredrecipies.isEmpty {
                VStack {
                    Image(systemName: "book.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    Text("Create Recipe")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
            } else {
                ForEach(groupedRecipes.keys.sorted(), id: \.self) { category in
                    if let recipesInCategory = groupedRecipes[category] {
                        let title = (category == 0 ? "Breakfast" : (category == 1 ? "Lunch" : "Dinner"))
                        SectionView(title: title, recipes: recipesInCategory) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(recipesInCategory) { recipe in
                                        CategoryCardView(categoryCardData: recipe)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let recipes: [Recipe]
    let content: Content
    @State private var showSavedRecipesView = false
    init(title: String, recipes: [Recipe], @ViewBuilder content: () -> Content) {
        self.title = title
        self.recipes = recipes
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack() {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    showSavedRecipesView = true
                }) {
                    Text("View All")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
            }
            .padding(.bottom, 10)
            content
        }
        .padding(.vertical, 10)
        .cornerRadius(15)
        .shadow(radius: 5, x: 0, y: 5)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showSavedRecipesView) {
            SavedRecipesView(title: title, filteredrecipieCategory: recipes.first?.category ?? 0)
        }
    }
}
