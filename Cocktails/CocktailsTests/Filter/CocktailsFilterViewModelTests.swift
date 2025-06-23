import Combine
import XCTest
@testable import Cocktails

final class CocktailsFilterViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.removeAll()
    }
    
    func testFetchCategoryFilterSuccess() {
        // Given
        let viewModel = CocktailsFilterViewModel(filterService: MockCocktailsFilterService())
        let expectation = expectation(description: "Cocktail filters contain data for 3 types - category, glass and alcoholic type.")
        
        // Then
        viewModel.$state
            .sink { state in
                if case .success(let filterModel) = state {
                    XCTAssertEqual(filterModel.categories.isEmpty, false, "Categories filters should not be empty.")
                    XCTAssertEqual(filterModel.glasses.isEmpty, false, "Glasses filters should not be empty.")
                    XCTAssertEqual(filterModel.alcoholicTypes.isEmpty, false, "Alcoholic type filters should not be empty.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.fetchFilters()
        
        waitForExpectations(timeout: 1)
    }
}
