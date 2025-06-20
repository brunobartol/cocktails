import Combine
import XCTest
@testable import Cocktails

final class CocktailListViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.removeAll()
    }
    
    func testSearchSuccessWithFullName() {
        // Given
        let viewModel = CocktailListViewModel(service: MockCocktailsListService(),
                                              onDetailsTap: { _ in },
                                              onFeelingLuckyTap: {})
        let expectation = expectation(description: "Cocktail list contains Mojito and it has all the data.")
        
        // Then
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let cocktails) = state {
                    guard let data = cocktails.first else {
                        XCTFail("Failed to find data.")
                        return
                    }
                    
                    XCTAssertEqual(data.title, "Mojito", "The title should match the mock title.")
                    XCTAssertEqual(data.ingredients, "White rum, soda, mint, sugar, lime", "Ingredients should match the mock ingredients.")
                    XCTAssertEqual(data.category, "Cocktail", "Category should match the mock category.")
                    XCTAssertEqual(data.alcoholic, "Alcoholic", "Alcoholic should match the mock category.")
                    XCTAssertEqual(data.imageUrl, "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg", "Image URL should match the mock category.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.searchText = "Mojito"
        
        waitForExpectations(timeout: 1)
    }
    
    func testSearchWithEmptyQuery() {
        // Given
        let viewModel = CocktailListViewModel(service: MockCocktailsListService(),
                                              onDetailsTap: { _ in },
                                              onFeelingLuckyTap: {})
        let expectation = expectation(description: "Cocktails list is empty.")
        
        // Then
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let cocktails) = state {
                    XCTAssertEqual(cocktails.isEmpty, true, "The list should be empty.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.searchText = ""
        
        waitForExpectations(timeout: 1)
    }
    
    func testSearchWithOneLetterQuery() {
        // Given
        let viewModel = CocktailListViewModel(service: MockCocktailsListService(),
                                              onDetailsTap: { _ in },
                                              onFeelingLuckyTap: {})
        let expectation = expectation(description: "Cocktails list has 2 results - all cocktails contain 'L' in the title.")
        
        // Then
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let cocktails) = state {
                    guard let first = cocktails.first, let last = cocktails.last else {
                        XCTFail("Failed to find data.")
                        return
                    }
                    
                    XCTAssertEqual(first.title, "Long Island", "First cocktail should be Long Island.")
                    XCTAssertEqual(last.title, "Acapulco", "First cocktail should be Acapulco.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.searchText = "L"
        
        waitForExpectations(timeout: 1)
    }
}
