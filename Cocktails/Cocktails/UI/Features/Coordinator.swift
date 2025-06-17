import Combine
import SwiftUI
import UIKit

final class Coordinator {
    private weak var navigationController: UINavigationController?
    private let cocktailsListService: CocktailsListServiceProtocol = CocktailsListService()
    private let cocktailsDetailsService: CocktailDetailsServiceProtocol = CocktailDetailsService()
    private let randomCocktailService: RandomCocktailServiceProtocol = RandomCocktailService()
    private(set) var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        
        self.navigationController?.navigationItem.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationItem.compactAppearance = navigationBarAppearance
        self.navigationController?.navigationItem.scrollEdgeAppearance = navigationBarAppearance
        
        let backButton = UIImage(named: "backButton")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.navigationController?.navigationBar.tintColor = .clear
        self.navigationController?.navigationBar.backIndicatorImage = backButton
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
    }
    
    func start() {
        guard let navigationController = navigationController else { return }
        
        let viewModel = CocktailsListVM(service: cocktailsListService)
        let rootView = CocktailsListView(viewModel: viewModel, onDetailsTapped: { [weak self] id in
            self?.showCocktailDetails(id)
        }, onFeelingLuckyButtonTapped: { [weak self] in
            self?.showRandomCocktailDetails()
        })
        let viewController = UIHostingController(rootView: rootView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showCocktailDetails(_ id: String) {
        guard let navigationController = navigationController else { return }
        
        let viewModel = CocktailDetailsVM(id: id, service: cocktailsDetailsService)
        let viewController = UIHostingController(rootView: CocktailDetailsView(viewModel: viewModel))
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
}
