import SwiftUI

// MARK: - Cocktail list -

struct CocktailList: View {
    @ObservedObject private var viewModel: CocktailListViewModel
    @FocusState private var isSearchFocused: Bool
    
    // MARK: - Init -
    
    init(viewModel: CocktailListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                search
                errorMessage
                list
            }
            
            feelingLuckyButton
        }
        .simultaneousGesture(
            TapGesture().onEnded { isSearchFocused = false }
        )
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

// MARK: - View components -

private extension CocktailList {
    private var search: some View {
        SearchBar(text: $viewModel.searchText, isFocused: $isSearchFocused)
            .padding(.horizontal, Constants.paddingMedium)
            .padding(.bottom, Constants.paddingSmall)
            .background(Color.sky)
            .shadow(color: .black.opacity(Constants.opacity), radius: Constants.radius, y: Constants.shadowYAxis)
    }
    
    @ViewBuilder
    private var errorMessage: some View {
        if case .error(let message) = viewModel.state,
           let errorMessage = message {
            Text(errorMessage)
                .appFont(size: Constants.fontSize, foregroundColor: .red)
        }
    }
    
    @ViewBuilder
    private var list: some View {
        if case .success(let cocktails) = viewModel.state {
            List {
                ForEach(cocktails) { cocktail in
                    Button(action: {
                        viewModel.onDetailsTap(cocktail.id)
                    }, label: {
                        CocktailCard(imageUrl: cocktail.imageUrl,
                                         title: cocktail.title,
                                         ingredients: cocktail.ingredients)
                    })
                    .buttonStyle(.plain)
                    .alignmentGuide(.listRowSeparatorLeading) {
                        $0[.leading]
                    }
                    .alignmentGuide(.listRowSeparatorTrailing) {
                        $0[.trailing]
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    private var feelingLuckyButton: some View {
        Button(action: viewModel.onFeelingLuckyTap, label: {
            Text(Constants.buttonTitle)
        })
        .buttonStyle(.primaryButton)
    }
}

// MARK: - Constants -

fileprivate enum Constants {
    static let buttonTitle = "FEELING LUCKY"
    
    static let zeroSpacing: CGFloat = 0
    static let paddingSmall: CGFloat = 10
    static let paddingMedium: CGFloat = 20
    static let minHeight: CGFloat = 1
    static let radius: CGFloat = 10
    static let opacity = 0.16
    static let shadowYAxis: CGFloat = 4
    static let fontSize: CGFloat = 16
}

#Preview {
    NavigationStack {
        CocktailList(viewModel: CocktailListViewModel(service: CocktailsListService(), onDetailsTap: { _ in
        }, onFeelingLuckyTap: {}))
    }
}
