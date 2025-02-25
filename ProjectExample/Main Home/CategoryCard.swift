//
//  CategoryCard.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 05/02/25.
//

import SwiftUI

struct CategoryCardView: View {
    let categoryCardData: Recipe
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @State private var showRecipeDetail = false
    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.15))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .frame(width: 150, height: 150)
            }
            VStack {
                if let data = categoryCardData.photo, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .clipped()
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                } else {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .clipped()
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text(categoryCardData.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Time (min):")
                        .font(.caption)
                        .foregroundColor(Color.primary.opacity(0.7))
                    HStack {
                        Text("\(categoryCardData.time)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                                    .frame(width: 30, height: 30)
                                Image(systemName: "bookmark.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundColor(categoryCardData.isBookMarked ? .red : .primary.opacity(0.4))
                                    .frame(width: 17, height: 17)
                                    .onTapGesture {
                                        categoryCardData.isBookMarked.toggle()
                                        try? modelContext.save()
                                        showToast(message: categoryCardData.isBookMarked ? "Saved" : "Unsaved")
                                    }
                            }
                            
                            ZStack {
                                Circle()
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                                    .frame(width: 30, height: 30)
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundColor(categoryCardData.isLiked ? .red : .primary.opacity(0.4))
                                    .frame(width: 17, height: 17)
                                    .onTapGesture {
                                        categoryCardData.isLiked.toggle()
                                        try? modelContext.save()
                                        showToast(message: categoryCardData.isLiked ? "Favourited" : "Unfavourited")
                                    }
                            }
                        }
                    }
                }
                .padding(5)
                .frame(width: 140, alignment: .leading)
            }
            .frame(width: 150, height: 180)
        }
        .frame(width: 150, height: 200)
        .onTapGesture {
            showRecipeDetail = true
        }
        .fullScreenCover(isPresented: $showRecipeDetail) {
            RecipeDetailSheet(recipe: categoryCardData)
        }
        .overlay(
            Group {
                if showToast {
                    VStack {
                        Spacer()
                        Text(toastMessage)
                            .font(.subheadline)
                            .padding()
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding(.bottom, 50)
                            .transition(.opacity)
                    }
                    .animation(.easeInOut(duration: 0.3), value: showToast)
                }
            }
        )
    }
    
    private func showToast(message: String) {
        toastMessage = message
        showToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}
