import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: Constants.verticalPadding,
                                leading: Constants.horizontalPadding,
                                bottom: Constants.verticalPadding,
                                trailing: Constants.horizontalPadding))
            .background(Capsule().fill(Color.sky))
            .appFont(size: Constants.fontSize, foregroundColor: .white, weight: .bold)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primaryButton: PrimaryButtonStyle { .init() }
}

// MARK: - Constants -

fileprivate enum Constants {
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 60
    static let fontSize: CGFloat = 16
}
