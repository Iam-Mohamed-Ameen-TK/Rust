//
//  CreateRecipeTests.swift
//  RustTests
//
//  Created by Mohamed Ameen on 14/02/25.
//

import XCTest
@testable import Rust 

class PhotoValidationTests: XCTestCase {
    var viewModel: RecipeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RecipeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testPhotoNotMissingWhenNotSubmitted() {
        // Given
        viewModel.isSubmitted = false
        viewModel.imageData = nil
        
        // Then
        XCTAssertFalse(viewModel.isPhotoMissing, "Photo should not be considered missing when form is not submitted")
    }
    
    func testPhotoMissingWhenSubmittedWithoutPhoto() {
        // Given
        viewModel.isSubmitted = true
        viewModel.imageData = nil
        
        // Then
        XCTAssertTrue(viewModel.isPhotoMissing, "Photo should be considered missing when form is submitted without photo")
    }
    
    func testPhotoNotMissingWhenSubmittedWithPhoto() {
        // Given
        viewModel.isSubmitted = true
        viewModel.imageData = Data([0x1, 0x2, 0x3]) // Sample image data
        
        // Then
        XCTAssertFalse(viewModel.isPhotoMissing, "Photo should not be considered missing when form is submitted with photo")
    }
    
    func testPhotoNotMissingWhenNotSubmittedWithPhoto() {
        // Given
        viewModel.isSubmitted = false
        viewModel.imageData = Data([0x1, 0x2, 0x3]) // Sample image data
        
        // Then
        XCTAssertFalse(viewModel.isPhotoMissing, "Photo should not be considered missing when form is not submitted, even with photo")
    }
}

// Helper class for testing
class RecipeViewModel {
    var isSubmitted: Bool = false
    var imageData: Data?
    
    var isPhotoMissing: Bool {
        isSubmitted && imageData == nil
    }
}
