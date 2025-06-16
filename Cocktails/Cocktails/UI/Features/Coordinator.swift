import SwiftUI
import UIKit

final class Coordinator {
    weak var navigationController: UINavigationController?
    
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
        
        let rootView = CocktailsListView(viewModel: CocktailsListVM(service: CocktailsListService(), onDetailsTap: { [weak self] id in
            self?.showCocktailDetails(id)
        }))
        let viewController = UIHostingController(rootView: rootView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showCocktailDetails(_ id: String) {
        guard let navigationController = navigationController else { return }
        
        let viewModel = CocktailDetailsVM(id: id, service: CocktailDetailsService())
        let viewController = UIHostingController(rootView: CocktailDetailsView(viewModel: viewModel))
        navigationController.pushViewController(viewController, animated: true)
    }
}
