import SwiftUI
import Combine

struct CocktailsFilterSearch: View {
    @ObservedObject private var viewModel: CocktailsFilterSearchViewModel
    @Environment(\.dismiss) private var dismiss
    
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
                    dismiss()
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
            CocktailsListComponent(cocktails: cocktails, onDetailsTap: viewModel.onDetailsTap)
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
