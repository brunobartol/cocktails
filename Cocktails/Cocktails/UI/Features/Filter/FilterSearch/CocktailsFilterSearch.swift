import SwiftUI
import Combine

struct CocktailsFilterSearch: View {
    @ObservedObject private var viewModel: CocktailsFilterSearchViewModel
    @EnvironmentObject private var router: Router
    
    init(viewModel: CocktailsFilterSearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: Constants.spacing) {
            searchCount
            list
        }
        .toolbarVisibility(.visible, for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .toolbarBackground(Color.sky, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    router.navigate(to: .cocktailList)
                }, label: {
                    Image("backButton")
                        .renderingMode(.original)
                })
            }
        }
    }
}

// MARK: - View components -

private extension CocktailsFilterSearch {
    @ViewBuilder
    private var list: some View {
        if case .success(let cocktails) = viewModel.state {
            CocktailsListComponent(cocktails: cocktails, onDetailsTap: { id in
                router.navigate(to: .cocktailDetails(id))
            })
        }
    }
    
    @ViewBuilder
    private var searchCount: some View {
        if case .success(let cocktails) = viewModel.state {
            Text("\(cocktails.count) \(Constants.recipesLabel)")
                .padding(.top, Constants.paddingSmall)
        }
    }
}

fileprivate enum Constants {
    static let recipesLabel = "recipes"
    
    static let spacing: CGFloat = 5
    static let paddingSmall: CGFloat = 10
}
