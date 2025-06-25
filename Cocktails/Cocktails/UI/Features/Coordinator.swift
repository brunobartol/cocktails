import Combine
import SwiftUI
import UIKit

final class Coordinator {
    private let navigationController: UINavigationController = UINavigationController()
    private let cocktailsListService: CocktailsListServiceProtocol = CocktailsListService()
    private let cocktailsDetailsService: CocktailDetailsServiceProtocol = CocktailDetailsService()
    private let randomCocktailService: RandomCocktailServiceProtocol = RandomCocktailService()
    private let cocktailFilterService: CocktailsFilterServiceProtocol = CocktailsFilterService()
    private let router = Router()
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
        setupRouterBinding()
    }
    
    private func setupNavigationBar() {
        self.navigationController.navigationBar.barTintColor = .clear
        self.navigationController.navigationBar.tintColor = .white
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let backButton = UIImage(named: "backButton")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        navigationBarAppearance.setBackIndicatorImage(backButton, transitionMaskImage: backButton)
        
        self.navigationController.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController.navigationBar.compactAppearance = navigationBarAppearance
        self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func showCocktailDetails(_ id: String) {
        let viewModel = CocktailDetailsViewModel(id: id, service: cocktailsDetailsService)
        let view = CocktailDetails(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showRandomCocktailDetails() {
        randomCocktailService.fetchRandom()
            .receive(on: RunLoop.main)
            .sink { _ in
                ()
            } receiveValue: { [weak self] dto in
                self?.router.navigate(to: .cocktailDetails(dto.id))
            }
            .store(in: &cancellables)
    }
    
    private func showFilter() {
        let view = CocktailsFilter(viewModel: cocktailsFilterViewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupFilterBinding() {
        cocktailsFilterViewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                if case .search(let results) = state {
                    self?.router.navigate(to: .filteredCocktailList(results))
                }
            }
            .store(in: &cancellables)
    }
    
    private func showFilteredSearch(_ filteredIds: [String]) {
        let viewModel = CocktailsFilterSearchViewModel(filteredIds: filteredIds, listService: cocktailsListService)
        let view = CocktailsFilterSearch(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupRouterBinding() {
        router.$currentRoute
            .receive(on: RunLoop.main)
            .sink { [weak self] route in
                guard let self else { return }
                
                switch route {
                case .cocktailList:
                    start()
                case .cocktailDetails(let id):
                    showCocktailDetails(id)
                case .filter:
                    showFilter()
                case .filteredCocktailList(let filteredIds):
                    showFilteredSearch(filteredIds)
                }
            }
            .store(in: &cancellables)
    }
    
    func start() {
        let viewModel = CocktailListViewModel(service: cocktailsListService, onFeelingLuckyTap: { [weak self] in
            self?.showRandomCocktailDetails()
        })
        let rootView = CocktailList(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: rootView)
        
        if navigationController.viewControllers.isEmpty {
            navigationController.pushViewController(viewController, animated: true)
            return
        }
        
        navigationController.popToRootViewController(animated: true)
    }
}
