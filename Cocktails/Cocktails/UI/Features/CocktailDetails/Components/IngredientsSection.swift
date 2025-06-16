import SwiftUI

// MARK: - Ingredients Section

struct IngredientsSection: View {
    let ingredients: [String?]
    let measures: [String?]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(Constants.title)
                .appFont(size: Constants.fontSizeTitle, foregroundColor: .ocean, weight: .bold)
                .padding(.bottom, Constants.paddingSmall)
            
            ForEach(0..<ingredients.count, id: \.self) { index in
                Group {
                    if let measure = measures[index], let ingredient = ingredients[index] {
                        Text(Constants.bullet) +
                        Text("\(measure) \(ingredient)")
                    }
                }
                .appFont(size: Constants.fontSizeBody, foregroundColor: .ocean)
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
    static let title = "Ingredients"
    static let bullet = AttributedString("\u{2022} ")
    
    static let spacing: CGFloat = 5
    static let fontSizeTitle: CGFloat = 16
    static let fontSizeBody: CGFloat = 14
    static let paddingSmall: CGFloat = 5
    static let horizontalPadding: CGFloat = 20
}
