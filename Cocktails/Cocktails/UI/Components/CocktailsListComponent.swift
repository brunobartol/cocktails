import SwiftUI

struct CocktailsListComponent: View {
    let cocktails: [CocktailModel]
    let onDetailsTap: (_ id: String) -> Void
    
    var body: some View {
        List {
            ForEach(cocktails) { cocktail in
                Button(action: {
                    onDetailsTap(cocktail.id)
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

fileprivate enum Constants {
    static let padding: CGFloat = 20
}
