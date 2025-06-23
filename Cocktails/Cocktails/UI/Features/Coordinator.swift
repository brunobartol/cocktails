import Combine
import SwiftUI
import UIKit

final class Coordinator {
    private let navigationController: UINavigationController = UINavigationController()
    private let cocktailsListService: CocktailsListServiceProtocol = CocktailsListService()
    private let cocktailsDetailsService: CocktailDetailsServiceProtocol = CocktailDetailsService()
    private let randomCocktailService: RandomCocktailServiceProtocol = RandomCocktailService()
    private let cocktailFilterService: CocktailsFilterServiceProtocol = CocktailsFilterService()
    private(set) var cancellables = Set<AnyCancellable>()
    
    private lazy var cocktailsFilterViewModel: CocktailsFilterViewModel = {
        CocktailsFilterViewModel(filterService: cocktailFilterService)
    }()
    
    lazy var rootViewController: UIViewController = {
        navigationController
    }()
    
    init() {
        setupNavigationBar()
        setupFilterBinding()
    }
    
    private func setupNavigationBar() {
        self.navigationController.navigationBar.barTintColor = .clear
        self.navigationController.navigationBar.tintColor = .white
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        
        let backButton = UIImage(named: "backButton")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        navigationBarAppearance.setBackIndicatorImage(backButton, transitionMaskImage: backButton)
        
        self.navigationController.navigationItem.standardAppearance = navigationBarAppearance
        self.navigationController.navigationItem.compactAppearance = navigationBarAppearance
        self.navigationController.navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func start() {
        let viewModel = CocktailListViewModel(service: cocktailsListService, onDetailsTap: { [weak self] id in
            self?.showCocktailDetails(id)
        }, onFeelingLuckyTap: { [weak self] in
            self?.showRandomCocktailDetails()
        }, onFilterTap: { [weak self] in
            self?.showFilter()
        })
        let rootView = CocktailList(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showCocktailDetails(_ id: String) {
        let viewModel = CocktailDetailsViewModel(id: id, service: cocktailsDetailsService)
        let viewController = UIHostingController(rootView: CocktailDetails(viewModel: viewModel))
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showRandomCocktailDetails() {
        randomCocktailService.fetchRandom()
            .receive(on: RunLoop.main)
            .sink { _ in
                ()
            } receiveValue: { [weak self] dto in
                self?.showCocktailDetails(dto.id)
            }
            .store(in: &cancellables)
    }
    
    private func showFilter() {
        let viewController = UIHostingController(rootView: CocktailsFilter(viewModel: cocktailsFilterViewModel))
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupFilterBinding() {
        cocktailsFilterViewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                if case .search(let results) = state {
                    self?.showFilteredSearch(results)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showFilteredSearch(_ filteredIds: [String]) {
        let viewModel = CocktailsFilterSearchViewModel(filteredIds: filteredIds, listService: cocktailsListService, onDetailsTap: { [weak self] id in
            self?.showCocktailDetails(id)
        })
        let viewController = UIHostingController(rootView: CocktailsFilterSearch(viewModel: viewModel))
        navigationController.pushViewController(viewController, animated: true)
    }
}
