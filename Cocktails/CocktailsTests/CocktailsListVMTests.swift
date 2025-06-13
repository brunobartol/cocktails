import XCTest
@testable import Cocktails

final class CocktailsListVMTests: XCTestCase {
    func testSearchWithFullName() {
        // Given
        let viewModel = CocktailsListVM(service: MockCocktailsListService())
        let expectation = expectation(description: "Cocktail list contains Mojito and it has all the data.")
        
        // When
        viewModel.search("Mojito")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !viewModel.state.cocktails.isEmpty {
                let data = viewModel.state.cocktails.first!
                
                XCTAssertEqual(data.title, "Mojito", "The title should match the mock title.")
                XCTAssertEqual(data.ingredients, "White rum, soda, mint, sugar, lime", "Ingredients should match the mock ingredients.")
                XCTAssertEqual(data.category, "Cocktail", "Category should match the mock category.")
                XCTAssertEqual(data.alcoholic, "Alcoholic", "Alcoholic should match the mock category.")
                XCTAssertEqual(data.imageUrl, "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg", "Image URL should match the mock category.")
                XCTAssertNil(viewModel.state.errorMessage, "Error message should be nil.")
                expectation.fulfill()
            } else {
                XCTFail("Failed to find data.")
            }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testSearchWithEmptyQuery() {
        // Given
        let viewModel = CocktailsListVM(service: MockCocktailsListService())
        let expectation = expectation(description: "Cocktails list is empty and error message is shown.")
        
        // When
        viewModel.search("")    // API doesn't return the full list for empty query, error is expected
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if viewModel.state.cocktails.isEmpty {
                XCTAssertNotNil(viewModel.state.errorMessage, "Error message should be shown to the user.")
                XCTAssertEqual(viewModel.state.errorMessage, "Oops! Something went wrong...", "Error message should be: Oops! Something went wrong...")
                expectation.fulfill()
            } else {
                XCTFail("Failed to find data.")
            }
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testSearchWithOneLetterQuery() {
        // Given
        let viewModel = CocktailsListVM(service: MockCocktailsListService())
        let expectation = expectation(description: "Cocktails list has 2 results - all cocktails contain 'L' in the title.")
        
        // When
        viewModel.search("L")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if viewModel.state.cocktails.count == 2 {
                XCTAssertNil(viewModel.state.errorMessage, "Error message should be nil.")
                XCTAssertEqual(viewModel.state.cocktails.first!.title, "Long Island", "First cocktail should be Long Island.")
                XCTAssertEqual(viewModel.state.cocktails.last!.title, "Acapulco", "First cocktail should be Acapulco.")
                expectation.fulfill()
            } else {
                XCTFail("Failed to find data.")
            }
        }
        
        waitForExpectations(timeout: 3)
    }
}
