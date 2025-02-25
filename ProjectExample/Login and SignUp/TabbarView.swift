//
//  TabbarView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 02/01/25.
//

import SwiftUI
import SwiftData

struct TabbarView: View {
    @Query var recipes: [Recipe]
    @State private var showCreateRecipe = false
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationView {
                    HomeView(recipes: recipes)
                        .padding(.bottom, 10)
                }
                .tag(0)
                
                NavigationView {
                    SavedRecipesView(title: "Saved Recipes", filteredrecipieCategory: -1)
                        .padding(.bottom, 10)
                }
                .tag(1)
                
                NavigationView {
                    NotificationView()
                        .padding(.bottom, 10)
                }
                .tag(2)
                
                NavigationView {
                    MyProfileView()
                        .padding(.bottom, 1)
                }
                .tag(3)
            }

            .accentColor(.red)
            .navigationBarBackButtonHidden(true)
            
            CustomTabBar(selectedTab: $selectedTab, showCreateRecipe: $showCreateRecipe)
        }
        .sheet(isPresented: $showCreateRecipe) {
            NavigationView {
                CreateRecipeView()
            }
        }
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        UITabBar.appearance().itemPositioning = .centered
        UITabBar.appearance().itemSpacing = 100
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showCreateRecipe: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            TabBarButton(imageName: "house.fill", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabBarButton(imageName: "bookmark.fill", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            // Center button
            Button(action: {
                showCreateRecipe = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .background(Circle().fill(colorScheme == .dark ? Color.black : Color.white))
                    .shadow(radius: 4)
            }
            .offset(y: -20)
            
            TabBarButton(imageName: "bell.fill", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            TabBarButton(imageName: "person.fill", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
        .frame(height: 60)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .background(Material.bar)
        .shadow(color: Color.primary.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

struct TabBarButton: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(isSelected ? .red : (colorScheme == .dark ? .gray : .black.opacity(0.7)))
                .frame(maxWidth: .infinity)
        }
    }
}

extension Color {
    static let adaptiveBackground = Color("AdaptiveBackground")
    static let adaptiveText = Color("AdaptiveText")
}
