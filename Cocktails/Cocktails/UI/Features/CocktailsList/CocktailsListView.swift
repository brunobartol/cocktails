import SwiftUI

struct CocktailsListView: View {
    @State private var searchText = ""
    @ObservedObject private var viewModel: CocktailsListVM
    @FocusState private var isSearchFocused: Bool
    
    init(viewModel: CocktailsListVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                SearchBar(text: $searchText, isFocused: $isSearchFocused)
                    .padding(.horizontal, Constants.paddingMedium)
                    .padding(.bottom, Constants.paddingSmall)
                    .background(Color.sky)
                    .shadow(color: .black.opacity(Constants.opacity), radius: Constants.radius, y: Constants.shadowYAxis)
                
                if let errorMessage = viewModel.state.errorMessage {
                    Text(errorMessage)
                        .appFont(size: Constants.fontSize, foregroundColor: .red)
                }
                
                List {
                    ForEach(viewModel.state.cocktails) { cocktail in
                        CocktailCardView(imageUrl: cocktail.imageUrl,
                                         title: cocktail.title,
                                         ingredients: cocktail.ingredients)
                    }
                }
                .listStyle(.plain)
            }
            
            Button(action: {
                // TODO: show random
            }, label: {
                Text(Constants.buttonTitle)
            })
            .buttonStyle(.primaryButton)
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.search(newValue)
        }
        .onTapGesture {
            isSearchFocused = false
        }
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
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
        CocktailsListView(viewModel: CocktailsListVM(service: MockCocktailsListService()))
    }
}
