import Foundation

struct CocktailDetailsModel: Identifiable {
    let id: String
    let imageUrl: String
    let title: String
    let ingredients: [String?]
    let measures: [String?]
    let category: String
    let alcoholic: String
    let instructions: String
    let glass: String
    let dateModified: String?
}

extension CocktailDetailsModel {
    init(from dto: CocktailDTO) {
        self.id = dto.id
        self.imageUrl = dto.imageUrl
        self.title = dto.name
        self.category = dto.category
        self.alcoholic = dto.alcoholic
        self.instructions = dto.instructions
        self.glass = dto.glass
        self.ingredients = dto.ingredients
        self.measures = dto.measures
        self.dateModified = DateHelper.formatLastModifiedDate(dto.dateModified)
    }
}
