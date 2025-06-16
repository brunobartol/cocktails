import SwiftUI

// MARK: - Directions Section

struct DirectionsSection: View {
    let instructions: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(Constants.title)
                .appFont(size: Constants.fontSizeTitle, foregroundColor: .ocean, weight: .bold)
                .padding(.bottom, Constants.paddingSmall)
            
            Text(instructions)
                .appFont(size: Constants.fontSizeBody, foregroundColor: .ocean)
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
    static let title = "Directions:"
    
    static let spacing: CGFloat = 10
    static let paddingSmall: CGFloat = 5
    static let horizontalPadding: CGFloat = 20
    static let fontSizeTitle: CGFloat = 16
    static let fontSizeBody: CGFloat = 14
}
