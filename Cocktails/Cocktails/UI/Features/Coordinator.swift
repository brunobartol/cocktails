import Combine
import SwiftUI
import UIKit

final class Coordinator {
    private let navigationController: UINavigationController = UINavigationController()
    private let cocktailsListService: CocktailsListServiceProtocol = CocktailsListService()
    private let cocktailsDetailsService: CocktailDetailsServiceProtocol = CocktailDetailsService()
    private let randomCocktailService: RandomCocktailServiceProtocol = RandomCocktailService()
    private(set) var cancellables = Set<AnyCancellable>()
    
    lazy var rootViewController: UIViewController = {
        navigationController
    }()
    
    init() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        
        self.navigationController.navigationItem.standardAppearance = navigationBarAppearance
        self.navigationController.navigationItem.compactAppearance = navigationBarAppearance
        self.navigationController.navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
        let backButton = UIImage(named: "backButton")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.navigationController.navigationBar.tintColor = .clear
        self.navigationController.navigationBar.backIndicatorImage = backButton
        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButton
    }
    
    func start() {
        let viewModel = CocktailListViewModel(service: cocktailsListService, onDetailsTap: { [weak self] id in
            self?.showCocktailDetails(id)
        }, onFeelingLuckyTap: { [weak self] in
            self?.showRandomCocktailDetails()
        }, onFilterTapped: { [weak self] in
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
        guard let navigationController = navigationController else { return }
        
        let viewModel = CocktailsFilterVM(filterService: CocktailsFilterService())
        let viewController = UIHostingController(rootView: CocktailsFilterView(viewModel: viewModel))
        navigationController.pushViewController(viewController, animated: true)
    }
}
