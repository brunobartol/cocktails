import SwiftUI

// MARK: - Last Modified Footer

struct LastModifiedFooter: View {
    let date: String?
    
    var body: some View {
        HStack {
            Text(Constants.title)
                .appFont(size: Constants.fontSize, foregroundColor: .ocean, weight: .bold)
            
            Text(date ?? Constants.undefinedDate)
                .appFont(size: Constants.fontSize, foregroundColor: .ocean)
        }
        .padding(.horizontal, Constants.padding)
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
    static let title = "Last modified:"
    static let undefinedDate: String = "N/A"
    
    static let fontSize: CGFloat = 16
    static let padding: CGFloat = 20
}
