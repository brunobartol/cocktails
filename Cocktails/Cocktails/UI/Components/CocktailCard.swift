import SwiftUI

// MARK: - Cocktail Card -

struct CocktailCard: View {
    let imageUrl: String
    let title: String
    let ingredients: String?
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            cocktailImage
            cocktailIngredients
        }
    }
}

// MARK: - View components -

private extension CocktailCard {
    @ViewBuilder
    private var cocktailImage: some View {
        if let url = URL(string: imageUrl) {
            AsyncImage(url: url, content: {
                $0.resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * Constants.imageRatio
                    }
            }, placeholder: {
                Image(systemName: "wineglass.fill")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * Constants.imageRatio
                    }
            })
            .padding(.vertical, Constants.padding)
        }
    }
    
    private var cocktailIngredients: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(title)
            
            if let ingredients = ingredients {
                Text(ingredients)
                    .lineLimit(Constants.lineLimit)
            }
            Spacer()
        }
    }
}

// MARK: - Constants -

fileprivate enum Constants {
    static let spacing: CGFloat = 23
    static let cornerRadius: CGFloat = 20
    static let imageRatio = 0.21
    static let padding: CGFloat = 20
    static let lineLimit = 1
}

#Preview {
    List {
        CocktailCard(imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg", title: "Mojito", ingredients: "White rum, soda, mint, sugar, lime")
        CocktailCard(imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg", title: "Long Island", ingredients: "White rum, soda, mint, sugar, lime")
        CocktailCard(imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg", title: "Negroni", ingredients: "White rum, soda, mint, sugar, lime")
    }
    .listStyle(.plain)
}
