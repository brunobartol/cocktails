import SwiftUI

struct CocktailDetails: View {
    @ObservedObject private var viewModel: CocktailDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: CocktailDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                cocktailImage
                
                Spacer()
            }
            
            detailsList
            
            if case .loading = viewModel.state {
                ProgressView()
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbarVisibility(.visible, for: .navigationBar)
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

private extension CocktailDetails {
    @ViewBuilder
    private var cocktailImage: some View {
        if case .success(cocktail: let cocktail) = viewModel.state,
           let url = URL(string: cocktail.imageUrl) {
            ZStack {
                AsyncImage(url: url, content: {
                    $0.resizable()
                        .scaledToFit()
                }, placeholder: {
                    ProgressView()
                        .scaledToFit()
                })
            }
        }
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: Constants.dividerHeight)
            .foregroundStyle(Color.lightSky)
    }
    
    @ViewBuilder
    private var ingredientsSection: some View {
        if case .success(let cocktail) = viewModel.state {
            VStack(alignment: .leading, spacing: Constants.Spacing.spacingExtraSmall) {
                Text(Constants.ingredientsSectiontitle)
                    .appFont(size: Constants.Font.fontSizeMedium, foregroundColor: .ocean, weight: .bold)
                    .padding(.bottom, Constants.Padding.paddingSmall)
                
                ForEach(0..<cocktail.ingredients.count, id: \.self) { index in
                    Group {
                        if let measure = cocktail.measures[index], let ingredient = cocktail.ingredients[index] {
                            Text(Constants.bullet) + Text("\(measure) \(ingredient)")
                        }
                    }
                    .appFont(size: Constants.Font.fontSizeSmall, foregroundColor: .ocean)
                }
            }
        }
    }
    
    @ViewBuilder
    private var directionsSection: some View {
        if case .success(let cocktail) = viewModel.state {
            VStack(alignment: .leading, spacing: Constants.Spacing.spacingSmall) {
                Text(Constants.directionsSectionTitle)
                    .appFont(size: Constants.Font.fontSizeMedium, foregroundColor: .ocean, weight: .bold)
                
                Text(cocktail.instructions)
                    .appFont(size: Constants.Font.fontSizeSmall, foregroundColor: .ocean)
            }
        }
    }
    
    @ViewBuilder
    private var lastModifiedSection: some View {
        if case .success(let cocktail) = viewModel.state {
            HStack {
                Text(Constants.lastModifiedSectionTitle)
                    .appFont(size: Constants.Font.fontSizeMedium, foregroundColor: .ocean, weight: .bold)
                
                Text(cocktail.dateModified ?? Constants.undefinedDate)
                    .appFont(size: Constants.Font.fontSizeMedium, foregroundColor: .ocean)
            }
        }
    }
    
    @ViewBuilder private var detailsList: some View {
        if case .success(let cocktail) = viewModel.state {
            VStack(alignment: .leading, spacing: Constants.Spacing.spacingLarge) {
                Text(cocktail.title)
                    .appFont(size: Constants.Font.fontSizeLarge, foregroundColor: .white, weight: .black)
                    .padding(.leading, Constants.Padding.paddingMedium)
                
                ScrollView {
                    VStack(spacing: Constants.Spacing.spacingMedium) {
                        Header(category: cocktail.category,
                               glass: cocktail.glass,
                               alcoholicType: cocktail.alcoholic)
                        
                        divider
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.spacingMedium) {
                            ingredientsSection
                            
                            divider
                            
                            directionsSection
                            
                            divider
                            
                            lastModifiedSection
                        }
                        .padding(.horizontal, Constants.Padding.paddingMedium)
                    }
                }
                .padding(.top, Constants.Padding.paddingMedium)
                .safeAreaPadding(.bottom, Constants.Padding.paddingMedium)
                .containerRelativeFrame(.vertical) { width, axis in
                    width * Constants.contentRatio
                }
                .background(Color.white)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: Constants.cornerRadius,
                                                  topTrailingRadius: Constants.cornerRadius))
            }
        }
    }
}

// MARK: - Constants -

fileprivate enum Constants {
    static let placeHolderImage = "wineglass.fill"
    static let ingredientsSectiontitle = "Ingredients"
    static let bullet = AttributedString("\u{2022} ")
    static let directionsSectionTitle = "Directions:"
    static let lastModifiedSectionTitle = "Last modified:"
    static let undefinedDate: String = "N/A"
    
    static let dividerHeight: CGFloat = 1
    static let cornerRadius: CGFloat = 40
    static let contentRatio: CGFloat = 0.7
    
    enum Font {
        static let fontSizeSmall: CGFloat = 14
        static let fontSizeMedium: CGFloat = 16
        static let fontSizeLarge: CGFloat = 24
    }
    
    enum Spacing {
        static let spacingExtraSmall: CGFloat = 5
        static let spacingSmall: CGFloat = 10
        static let spacingMedium: CGFloat = 20
        static let spacingLarge: CGFloat = 37
    }
    
    enum Padding {
        static let paddingSmall: CGFloat = 5
        static let paddingMedium: CGFloat = 20
    }
}
