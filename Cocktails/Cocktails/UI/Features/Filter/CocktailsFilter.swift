import SwiftUI

struct CocktailsFilter: View {
    @ObservedObject private var viewModel: CocktailsFilterViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: CocktailsFilterViewModel) {
        self.viewModel = viewModel
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: Constants.dividerHeight)
            .foregroundStyle(Color.lightSky)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ScrollView {
                    list
                }
                
                spinner
                
                Button(action: viewModel.search, label: {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.primaryButton)
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
        .toolbarVisibility(.visible, for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .toolbarBackground(Color.sky, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("backButton")
                        .renderingMode(.original)
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.resetFilters()
                }, label: {
                    Text(Constants.resetButtonTitle)
                        .foregroundStyle(.white)
                })
                .buttonStyle(.plain)
                .disabled(viewModel.selectedFilters.isEmpty)
            }
        }
        .onAppear(perform: viewModel.fetchFilters)
    }
}

// MARK: - View components -

private extension CocktailsFilter {
    private var list: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.spacingLarge) {
            if case .success(let filterModel) = viewModel.state {
                filterSection(title: Constants.categoriesTitle, filters: filterModel.categories)
                
                divider
                
                filterSection(title: Constants.glassesTitle, filters: filterModel.glasses)
                
                divider
                
                filterSection(title: Constants.alcoholicTypesTitle, filters: filterModel.alcoholicTypes)
            }
        }
        .padding(Constants.horizontalPadding)
    }
    
    private func filterSection(title: String, filters: [Filter]) -> some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.spacingSmall) {
            Text(title)
                .appFont(size: Constants.fontSizeTitle, foregroundColor: .ocean, weight: .bold)
            
            VStack(alignment: .leading, spacing: Constants.Spacing.spacingMedium) {
                ForEach(filters, id: \.id) { filter in
                    Button(action: {
                        viewModel.toggleFilter(filter)
                    }, label: {
                        HStack(spacing: Constants.Spacing.spacingSmall) {
                            Button(action: {
                                viewModel.toggleFilter(filter)
                            }, label: {
                                viewModel.isActiveFilter(filter.id) ? Image("radioButtonOn").renderingMode(.original) : Image("radioButtonOff").renderingMode(.original)
                            })
                            .buttonStyle(.plain)
                            
                            Text(filter.value)
                                .appFont(size: Constants.fontSizeBody, foregroundColor: .ocean)
                        }
                    })
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    @ViewBuilder
    private var spinner: some View {
        if case .loading = viewModel.state {
            ProgressView()
        }
    }
}

// MARK: - Constants -

fileprivate struct Constants {
    private init() {}
    
    static let navigationTitle = "Filters"
    static let categoriesTitle = "Category:"
    static let glassesTitle = "Glass:"
    static let alcoholicTypesTitle = "Alcohol:"
    static let resetButtonTitle = "Reset"
    
    enum Spacing {
        static let spacingSmall: CGFloat = 10
        static let spacingMedium: CGFloat = 12
        static let spacingLarge: CGFloat = 20
    }
    
    static let fontSizeTitle: CGFloat = 16
    static let fontSizeBody: CGFloat = 14
    static let dividerHeight: CGFloat = 1
    static let horizontalPadding: CGFloat = 20
}
