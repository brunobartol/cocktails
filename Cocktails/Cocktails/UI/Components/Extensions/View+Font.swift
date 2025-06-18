import SwiftUI

private struct AppFont: ViewModifier {
    let size: CGFloat
    let foregroundColor: Color
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Mulish-Regular", size: size))
            .fontWeight(weight)
            .foregroundStyle(foregroundColor)
    }
}

extension View {
    public func appFont(size: CGFloat, foregroundColor: Color = .black, weight: Font.Weight = .regular) -> some View {
        modifier(AppFont(size: size, foregroundColor: foregroundColor, weight: weight))
    }
}
