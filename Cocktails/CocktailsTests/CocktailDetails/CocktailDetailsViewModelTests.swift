import Combine
import XCTest
@testable import Cocktails

final class CocktailDetailsViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.removeAll()
    }
    
    func testFetchDetailsSuccess() {
        // Given
        let id = "1100"
        let viewModel = CocktailDetailsViewModel(id: id, service: MockCocktailDetailsService())
        let expectation = expectation(description: "Cocktail details show Mojito and it has all the data.")
        
        // Then
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let cocktail) = state {
                    XCTAssertEqual(cocktail.title, "Mojito", "The title should match the mock title.")
                    XCTAssertEqual(cocktail.ingredients, ["White rum", "soda", "mint", "sugar", "lime"], "Ingredients should match the mock ingredients.")
                    XCTAssertEqual(cocktail.category, "Cocktail", "Category should match the mock category.")
                    XCTAssertEqual(cocktail.alcoholic, "Alcoholic", "Alcoholic should match the mock category.")
                    XCTAssertEqual(cocktail.imageUrl, "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg", "Image URL should match the mock category.")
                    XCTAssertEqual(cocktail.instructions, "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.", "Instructions should match Mojito instructions.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - view model triggers fetch in initializer
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchDetailsError() {
        // Given
        let id = "110044"
        let viewModel = CocktailDetailsViewModel(id: id, service: MockCocktailDetailsService())
        let expectation = expectation(description: "Cocktail data is empty.")
        
        // Then
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, "Oops! Something went wrong...", "The error message should match 'Oops! Something went wrong...'")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - view model triggers fetch in initializer
        
        waitForExpectations(timeout: 1)
    }
}
