//
//  RecipeFilterTests.swift
//  RustTests
//
//  Created by Mohamed Ameen on 14/02/25.
//

import XCTest
@testable import Rust

class RecipeFilterTests: XCTestCase {
    var viewModel: RecipeListViewModel!
    
    override func setUp() {
        super.setUp()
        // Initialize with sample recipes
        let sampleRecipes = [
            Recipe(title: "Pancakes"),
            Recipe(title: "Spaghetti Carbonara"),
            Recipe(title: "Apple Pie"),
            Recipe(title: "Chicken Curry"),
            Recipe(title: "Baked Apple")
        ]
        viewModel = RecipeListViewModel(recipes: sampleRecipes)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testEmptySearchTextReturnsAllRecipes() {
        // Given
        viewModel.searchText = ""
        
        // When
        let filtered = viewModel.filteredrecipies
        
        // Then
        XCTAssertEqual(filtered.count, 5, "Empty search should return all recipes")
        XCTAssertEqual(filtered, viewModel.recipes, "Empty search should return unfiltered recipe array")
    }
    
    func testWhitespaceOnlySearchTextReturnsAllRecipes() {
        // Given
        viewModel.searchText = "   \n  "
        
        // When
        let filtered = viewModel.filteredrecipies
        
        // Then
        XCTAssertEqual(filtered.count, 5, "Whitespace-only search should return all recipes")
        XCTAssertEqual(filtered, viewModel.recipes, "Whitespace-only search should return unfiltered recipe array")
    }
    
    func testExactMatchSearch() {
        // Given
        viewModel.searchText = "Pancakes"
        
        // When
        let filtered = viewModel.filteredrecipies
        
        // Then
        XCTAssertEqual(filtered.count, 1, "Should find exactly one match")
        XCTAssertEqual(filtered.first?.title, "Pancakes", "Should find exact match")
    }
    
    func testCaseInsensitiveSearch() {
        // Given
        viewModel.searchText = "pancakes"
        
        // When
        let filtered = viewModel.filteredrecipies
        
        // Then
        XCTAssertEqual(filtered.count, 1, "Should find case-insensitive match")
        XCTAssertEqual(filtered.first?.title, "Pancakes", "Should find match regardless of case")
    }
    
    func testPartialWordSearch() {
        // Given
        viewModel.searchText = "Apple"
        
        // When
        let filtered = viewModel.filteredrecipies
        
        // Then
        XCTAssertEqual(filtered.count, 2, "Should find all recipes containing 'Apple'")
        XCTAssertTrue(filtered.contains(where: { $0.title == "Apple Pie" }))
        XCTAssertTrue(filtered.contains(where: { $0.title == "Baked Apple" }))
    }
    
    func testNoMatchSearch() {
        // Given
        viewModel.searchText = "Burger"
        
        // When
        let filtered = viewModel.filteredrecipies
        
        // Then
        XCTAssertTrue(filtered.isEmpty, "Should return empty array when no matches found")
    }
    
    func testSearchWithWhitespacePadding() {
        // Given
        viewModel.searchText = "  Curry  "
        
        // When
        let filtered = viewModel.filteredrecipies
        
        // Then
        XCTAssertEqual(filtered.count, 1, "Should find matches after trimming whitespace")
        XCTAssertEqual(filtered.first?.title, "Chicken Curry")
    }
}

// Helper classes for testing
class RecipeListViewModel {
    var recipes: [Recipe]
    var searchText: String = ""
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
    
    var filteredrecipies: [Recipe] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearch.isEmpty else { return recipes }
        return recipes.filter { $0.title.localizedCaseInsensitiveContains(trimmedSearch) }
    }
}

struct Recipe: Equatable {
    let title: String
}
