import SwiftUI
import OrderedCollections

struct CocktailDetailsView: View {
    @ObservedObject private var viewModel: CocktailDetailsVM
    
    init(viewModel: CocktailDetailsVM) {
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
                if let urlString = viewModel.state.cocktail?.imageUrl,
                   let url = URL(string: urlString) {
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
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: Constants.titleSpacing) {
                Text(viewModel.state.cocktail?.title ?? "")
                    .appFont(size: Constants.fontSize, foregroundColor: .white, weight: .black)
                    .padding(.leading, Constants.padding)
                
                ScrollView {
                    VStack(spacing: Constants.spacing) {
                        Header(category: viewModel.state.cocktail?.category ?? "",
                               glass: viewModel.state.cocktail?.glass ?? "",
                               alcoholicType: viewModel.state.cocktail?.alcoholic ?? "")
                        
                        divider
                        
                        VStack(alignment: .leading) {
                            IngredientsSection(ingredients: viewModel.state.cocktail?.ingredients ?? [],
                                               measures: viewModel.state.cocktail?.measures ?? [])
                            
                            divider
                            
                            DirectionsSection(instructions: viewModel.state.cocktail?.instructions ?? "")
                            
                            divider
                            
                            LastModifiedFooter(date: viewModel.state.modifiedDate)
                        }
                        .padding(.horizontal, Constants.padding)
                    }
                }
                .padding(.top, Constants.padding)
                .safeAreaPadding(.bottom, Constants.padding)
                .containerRelativeFrame(.vertical) { width, axis in
                    width * Constants.contentRatio
                }
                .background(Color.white)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: Constants.cornerRadius,
                                                  topTrailingRadius: Constants.cornerRadius))
            }
            
            if viewModel.state.isLoading {
                ProgressView()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
    static let placeHolderImage = "wineglass.fill"
    
    static let dividerHeight: CGFloat = 1
    static let spacing: CGFloat = 20
    static let titleSpacing: CGFloat = 37
    static let padding: CGFloat = 20
    static let fontSize: CGFloat = 24
    static let cornerRadius: CGFloat = 40
    static let contentRatio: CGFloat = 0.7
}

// MARK: - Preview

#Preview {
    CocktailDetailsView(viewModel: CocktailDetailsVM(id: "1100", service: MockCocktailDetailsService()))
}
