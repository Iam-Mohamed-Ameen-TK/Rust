//
//  CreateRecipeView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 03/01/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct CreateRecipeView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private let selectionOptions = ["Breakfast", "Lunch", "Dinner"]
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var time: Int?
    @State private var imageData: Data?
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var category: String = "Breakfast"
    @State private var ingredients: [IngredientItem] = [IngredientItem()]
    @State private var hoveredCategory: String? = nil
    @State private var showSuccessAlert: Bool = false
    @State private var isSubmitted: Bool = false
    @State private var isTitleMissing: Bool = false
    @State private var isDescriptionMissing: Bool = false
    @State private var isTimeMissing: Bool = false
    @State private var isIngredientsMissing: Bool = false
    
    var recipe: Recipe?
    
    var isPhotoMissing: Bool {
        isSubmitted && imageData == nil
    }
    
    init(recipe: Recipe? = nil) {
        self.recipe = recipe
        if let ingredients = recipe?.ingredients {
            let ingrdnts = ingredients.compactMap { ingredient -> IngredientItem? in
                if !ingredient.isEmpty {
                    let components = ingredient.components(separatedBy: " (")
                    if components.count == 2 {
                        let amount = components[1].trimmingCharacters(
                            in: CharacterSet(charactersIn: ")")
                        )
                        return IngredientItem(
                            name: components[0],
                            amount: amount
                        )
                    }
                    return IngredientItem(name: components[0], amount: "")
                }
                return nil
            }
            _ingredients = State(
                initialValue: ingrdnts.isEmpty ? [IngredientItem()] : ingrdnts
            )
        } else {
            _ingredients = State(initialValue: [IngredientItem()])
        }
        
        _title = State(initialValue: recipe?.title ?? "")
        _time = State(initialValue: recipe?.time)
        _imageData = State(initialValue: recipe?.photo)
        _details = State(initialValue: recipe?.details ?? "")
        _category = State(initialValue: {
            switch recipe?.category {
            case 0: return "Breakfast"
            case 1: return "Lunch"
            case 2: return "Dinner"
            default: return "Breakfast"
            }
        }())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(recipe == nil ? "Create Recipe" : "Edit Recipe")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                if recipe != nil {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                colorScheme == .dark ? Color(
                                    UIColor.systemGray6
                                ) : .white
                            )
                            .foregroundColor(Color.accentColor)
                            .cornerRadius(10)
                            .shadow(
                                color: colorScheme == .dark ? .black
                                    .opacity(0.2) : .gray
                                    .opacity(
                                        0.2
                                    ),
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            )
                    }
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let data = imageData, let uiImage = UIImage(
                            data: data
                        ) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(editOverlay)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color(uiColor: .secondarySystemBackground)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .overlay(
                                    Image(systemName: "photo.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(
                                            isPhotoMissing ? .red : .secondary
                                        )
                                )
                                .overlay(editOverlay)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            isPhotoMissing ? Color.red : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                        }
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        if let newItem = newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(
                                    type: Data.self
                                ) {
                                    await MainActor.run {
                                        imageData = data
                                    }
                                }
                            }
                        }
                    }
                    
                    if isPhotoMissing {
                        Text("Photo is required")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                
                TextField("Recipe Title", text: $title)
                    .textFieldStyle(RecipeTextFieldStyle())
                    .padding(.vertical, 5)
                
                if isTitleMissing {
                    Text("Title is required")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.leading, 5)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipe Description")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $details)
                        .frame(height: 100)
                        .padding(10)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    isDescriptionMissing ? Color.red : Color.secondary
                                        .opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                        .onChange(of: details) { oldValue, newValue in
                            if newValue.count > 600 {
                                details = String(newValue.prefix(600))
                            }
                        }
                    
                    HStack {
                        Spacer()
                        Text("\(details.count)/600")
                            .font(.caption)
                            .foregroundColor(
                                details.count == 600 ? .red : .gray
                            )
                    }
                    
                    if isDescriptionMissing {
                        Text("Description is required")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        ForEach(selectionOptions, id: \.self) { cat in
                            CategoryCard(
                                category: cat,
                                isSelected: category == cat,
                                isHovered: hoveredCategory == cat
                            )
                            .onHover { isHovered in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    hoveredCategory = isHovered ? cat : nil
                                }
                            }
                            .onTapGesture {
                                withAnimation(
                                    .spring(response: 0.3, dampingFraction: 0.7)
                                ) {
                                    category = cat
                                }
                            }
                        }
                    }
                    .frame(height: 120)
                    
                    RecipeDataView(
                        icon: "clock",
                        title: "Time",
                        value: time != nil ? "\(time!) min" : "",
                        iconColor: .red
                    ) {
                        HStack {
                            TextField("0", value: $time, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RecipeTimeFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            isTimeMissing ? Color.red : Color.clear,
                                            lineWidth: 1
                                        )
                                )
                            
                            Text("min")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if isTimeMissing {
                        Text("Time is required")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Spacer()
                        Button(action: {
                            ingredients.append(IngredientItem())
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.green)
                        }
                    }
                    
                    ForEach($ingredients) { $ingredient in
                        CreateRecipeIngredientsView(ingredient: $ingredient) {
                            if ingredients.count > 1 {
                                ingredients.removeAll { $0.id == ingredient.id }
                            }
                        }
                    }
                    
                    if isIngredientsMissing {
                        Text("At least one ingredient with a name is required")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                .padding(.top)
                
                Button(action: validateAndSave) {
                    Text(recipe == nil ? "Save Recipe" : "Update Recipe")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
        }
        .padding(20)
        .background(Color(uiColor: .systemBackground))
        .foregroundColor(.primary)
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text(
                    recipe == nil ? "You created a recipe successfully!" : "You updated a recipe successfully!"
                ),
                dismissButton: .default(Text("OK")) {
                    dismiss()
                }
            )
        }
    }
  
}

#Preview {
    NavigationStack {
        CreateRecipeView()
            .modelContainer(for: Recipe.self, inMemory: true)
    }
}

extension CreateRecipeView {
    
    //   MARK: View
    
    private var editOverlay: some View {
        ZStack {
            Circle()
                .fill(Color(uiColor: .systemBackground))
                .frame(width: 40, height: 40)
                .shadow(radius: 2)
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
        }
        .padding(10)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topTrailing
        )
    }
    
    // MARK: Fenctions
    
    private func resetFields() {
        title = ""
        details = ""
        time = nil
        imageData = nil
        category = "Breakfast"
        ingredients = [IngredientItem()]
        isSubmitted = false
        isTitleMissing = false
        isDescriptionMissing = false
        isTimeMissing = false
        isIngredientsMissing = false
    }
    
    private func saveRecipe() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let recipe = recipe {
            recipe.title = trimmedTitle
            recipe.details = details
            recipe.time = time ?? 0
            recipe.photo = imageData
            recipe.category = category == "Breakfast" ? 0 : (
                category == "Lunch" ? 1 : 2
            )
            recipe.ingredients = ingredients.map { item in
                let name = item.name.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                let amount = item.amount.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                return name + (amount.isEmpty ? "" : " (\(amount))")
            }
        } else {
            let newRecipe = Recipe(
                id: UUID(),
                title: trimmedTitle,
                details: details,
                time: time ?? 0,
                photo: imageData,
                category: category == "Breakfast" ? 0 : (
                    category == "Lunch" ? 1 : 2
                ),
                ingredients: ingredients.map { item in
                    let name = item.name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    let amount = item.amount.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    return name + (amount.isEmpty ? "" : " (\(amount))")
                }
            )
            context.insert(newRecipe)
            
            // Add notification when a new recipe is created
            NotificationManager.shared.addNotification(
                title: "Recipe Created",
                content: "New recipe '\(trimmedTitle)' created successfully"
            )
        }
        
        do {
            try context.save()
            resetFields()
            showSuccessAlert = true
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
    
    private func validateAndSave() {
        isSubmitted = true
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        isTitleMissing = trimmedTitle.isEmpty
        isDescriptionMissing = trimmedDetails.isEmpty
        isTimeMissing = time == nil || time == 0
        isIngredientsMissing = ingredients.isEmpty || ingredients
            .contains {
                $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        
        if isTitleMissing || isDescriptionMissing || isTimeMissing || isIngredientsMissing || imageData == nil {
            return
        }
        
        saveRecipe()
    }
}
