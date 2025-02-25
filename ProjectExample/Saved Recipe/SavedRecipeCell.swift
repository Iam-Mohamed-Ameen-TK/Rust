//
//  SavedRecipeCell.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 08/02/25.
//

//import SwiftUI
//import SwiftData
//
//struct SavedRecipesCellView: View {
//    @Environment(\.modelContext) private var context
//    @Environment(\.colorScheme) private var colorScheme
//    var recipie: Recipe
//    var onUpdate: () -> ()
//    @State private var showDeleteAlert = false
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                if let data = recipie.photo, let uiImage = UIImage(data: data) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(maxWidth: .infinity, maxHeight: 150)
//                        .clipShape(Rectangle())
//                        .clipped()
//                } else {
//                    Image(systemName: "photo.circle")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(maxWidth: .infinity, maxHeight: 150)
//                        .clipShape(Rectangle())
//                        .clipped()
//                        .foregroundColor(colorScheme == .dark ? .gray : .gray.opacity(0.5))
//                }
//                HStack {
//                    Text(recipie.title)
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundColor(colorScheme == .dark ? .white : .black)
//
//                    Spacer()
//                    Button {
//                        DispatchQueue.main.async {
//                            onUpdate()
//                        }
//                    } label: {
//                        Text("Update")
//                            .font(.caption)
//                            .padding(6)
//                            .background(colorScheme == .dark ? Color.blue : Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(6)
//                    }
//
//                    Button(action: {
//                        showDeleteAlert = true
//                    }) {
//                        Text("Delete")
//                            .font(.caption)
//                            .padding(6)
//                            .background(colorScheme == .dark ? Color.red : Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(6)
//                    }
//                }
//                .padding(.top, 5)
//            }
//        }
//        .padding()
//        .background(colorScheme == .dark ? Color(UIColor.systemGray6).opacity(0.2) : Color(UIColor.systemGray6))
//        .cornerRadius(10)
//        .alert("Delete Recipe", isPresented: $showDeleteAlert) {
//            Button("Cancel", role: .cancel) {}
//            Button("Delete", role: .destructive) {
//                deleteRecipe(recipie)
//            }
//        } message: {
//            Text("Are you sure you want to delete this recipe?")
//        }
//    }
//
//    private func deleteRecipe(_ recipe: Recipe) {
//        context.delete(recipe)
//        do {
//            try context.save()
//        } catch {
//            print("Error deleting recipe: \(error)")
//        }
//    }
//}

import SwiftUI
import SwiftData

struct SavedRecipesCellView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    var recipie: Recipe
    var onUpdate: () -> ()
    @State private var showDeleteAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let data = recipie.photo, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .clipShape(Rectangle())
                        .clipped()
                } else {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .clipShape(Rectangle())
                        .clipped()
                        .foregroundColor(colorScheme == .dark ? .gray : .gray.opacity(0.5))
                }
                HStack {
                    Text(recipie.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)

                    Spacer()
                    Button {
                        DispatchQueue.main.async {
                            onUpdate()
                            // Add notification when recipe is updated
                            NotificationManager.shared.addNotification(
                                title: "Recipe Updated",
                                content: "Recipe '\(recipie.title)' has been updated."
                            )
                        }
                    } label: {
                        Text("Update")
                            .font(.caption)
                            .padding(6)
                            .background(colorScheme == .dark ? Color.blue : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }

                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Text("Delete")
                            .font(.caption)
                            .padding(6)
                            .background(colorScheme == .dark ? Color.red : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(UIColor.systemGray6).opacity(0.2) : Color(UIColor.systemGray6))
        .cornerRadius(10)
        .alert("Delete Recipe", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                // Add notification when recipe is deleted
                NotificationManager.shared.addNotification(
                    title: "Recipe Deleted",
                    content: "Recipe '\(recipie.title)' has been deleted."
                )
                deleteRecipe(recipie)
            }
        } message: {
            Text("Are you sure you want to delete this recipe?")
        }
    }

    private func deleteRecipe(_ recipe: Recipe) {
        context.delete(recipe)
        do {
            try context.save()
        } catch {
            print("Error deleting recipe: \(error)")
        }
    }
}
