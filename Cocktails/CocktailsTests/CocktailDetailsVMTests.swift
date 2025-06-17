import XCTest
@testable import Cocktails

final class CocktailDetailsVMTests: XCTestCase {
    func testFetchDetails() {
        // Given
        let viewModel = CocktailDetailsVM(id: "1100", service: MockCocktailDetailsService())
        let expectation = expectation(description: "Cocktail details contains Mojito data.")
        
        // When - fetch is being executed in the init of view model
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let cocktail = viewModel.state.cocktail else {
                XCTFail("Failed to find data.")
                return
            }
            
            XCTAssertEqual(cocktail.title, "Mojito", "The title should match the mock title.")
            XCTAssertEqual(cocktail.ingredients, ["White rum", "soda", "mint", "sugar", "lime"], "Ingredients should match the mock ingredients.")
            XCTAssertEqual(cocktail.category, "Cocktail", "Category should match the mock category.")
            XCTAssertEqual(cocktail.alcoholic, "Alcoholic", "Alcoholic should match the mock category.")
            XCTAssertEqual(cocktail.imageUrl, "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg", "Image URL should match the mock category.")
            XCTAssertEqual(cocktail.instructions, "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.", "Instructions should match Mojito instructions.")
            XCTAssertNil(viewModel.state.errorMessage, "Error message should be nil.")
            XCTAssertEqual(viewModel.state.isLoading, false, "Loading should be finished and user should not see the loading indicator.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    func testFetchError() {
        // Given
        let viewModel = CocktailDetailsVM(id: "007", service: MockCocktailDetailsService())
        let expectation = expectation(description: "Cocktail details contains Mojito data.")
        
        // When - fetch is being executed in the init of view model
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(viewModel.state.errorMessage, "Oops! Something went wrong...", "The error message should match the something went wrong description.")
            XCTAssertNil(viewModel.state.cocktail, "Cocktail should be nil.")
            XCTAssertEqual(viewModel.state.isLoading, false, "Loading should be finished and user should not see the loading indicator.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
