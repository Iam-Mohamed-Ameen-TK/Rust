//
//  MyProfileView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 03/01/25.
//

import SwiftUI
import SwiftData

struct MyProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var profiles: [Profile]
    @Query(filter: #Predicate<Recipe> { recipe in
        recipe.isLiked == true
    }) private var likedRecipes: [Recipe]
    @State private var showingEditProfile = false
    @State private var selectedRecipe: Recipe?
    
    private var currentProfile: Profile? {
        profiles.first
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Profile")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 10)

            HStack {
                if let profile = currentProfile,
                   let imageData = profile.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 110)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                        )
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 110)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .foregroundColor(.gray)
                }
                
                Spacer()
                Button(action: {
                    showingEditProfile = true
                }) {
                    Text("Edit Profile")
                        .padding()
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 120, height: 40)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                )
            }
            .frame(height: 100)

            if let profile = currentProfile {
                Text(profile.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(profile.bio)
                    .font(.custom("Poppins-Regular", size: 20))
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
            } else {
                Text("Add Profile")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }

            Text("My Favourites")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.red)
                .cornerRadius(10)
                .font(.system(size: 16, weight: .bold))

            ScrollView {
                ForEach(likedRecipes) { recipe in
                    LikedRecipeCard(recipe: recipe, selectedRecipe: $selectedRecipe)
                }
            }
        }
        .padding(20)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditProfile) {
            NavigationStack {
                EditProfileView()
            }
        }
        .sheet(item: $selectedRecipe) { recipe in
            RecipeDetailSheet(recipe: recipe)
        }
    }
}

struct LikedRecipeCard: View {
    let recipe: Recipe
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedRecipe: Recipe?
    
    var body: some View {
        Button(action: {
            selectedRecipe = recipe
        }) {
            ZStack(alignment: .bottomLeading) {
                if let photoData = recipe.photo, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0.5), .clear]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(recipe.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("\(recipe.time) min")
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                }
                .padding(20)
            }
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.vertical, 5)
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
    }
}

#Preview {
    MyProfileView()
}
