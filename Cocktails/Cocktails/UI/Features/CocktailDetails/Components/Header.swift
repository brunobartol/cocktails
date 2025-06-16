import SwiftUI

// MARK: - Header Item

struct HeaderItem: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack(spacing: Constants.spacing) {
            Image(image)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
            Text(title)
                .appFont(size: Constants.fontSize, foregroundColor: .ocean)
        }
    }
}

// MARK: - Header

struct Header: View {
    let category: String
    let glass: String
    let alcoholicType: String
    
    var body: some View {
        HStack {
            HeaderItem(image: Constants.categoryImage, title: category)
                .frame(maxWidth: .infinity)
            HeaderItem(image: Constants.glassImage, title: glass)
                .frame(maxWidth: .infinity)
            HeaderItem(image: Constants.alcoholicImage, title: alcoholicType)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
    static let categoryImage = "category"
    static let glassImage = "glass"
    static let alcoholicImage = "alcoholicType"
    
    static let spacing: CGFloat = 5
    static let imageSize: CGFloat = 47
    static let fontSize: CGFloat = 14
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        Header(category: "Category", glass: "Glass", alcoholicType: "Alcoholic Type")
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(Color.sky)
}
