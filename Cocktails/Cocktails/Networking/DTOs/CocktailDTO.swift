import Foundation

struct CocktailDTO {
    let id: String
    let name: String
    let category: String
    let alcoholic: String
    let imageUrl: String
    let instructions: String
    let glass: String
    let dateModified: String?
    var ingredients: [String?] = []
    var measures: [String?] = []
    
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case imageUrl = "strDrinkThumb"
        case alcoholic = "strAlcoholic"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
        case instructions = "strInstructions"
        case glass = "strGlass"
        case dateModified
    }
}

extension CocktailDTO: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(String.self, forKey: .category)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.alcoholic = try container.decode(String.self, forKey: .alcoholic)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.glass = try container.decode(String.self, forKey: .glass)
        self.dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)
        
        self.ingredients = try mapIngredients(for: container)
        self.measures = try mapMeasures(for: container)
    }
    
    private func mapIngredients(for container: KeyedDecodingContainer<CodingKeys>) throws -> [String?] {
        let ingredient1: String? = try container.decodeIfPresent(String.self, forKey: .ingredient1)
        let ingredient2: String? = try container.decodeIfPresent(String.self, forKey: .ingredient2)
        let ingredient3: String? = try container.decodeIfPresent(String.self, forKey: .ingredient3)
        let ingredient4: String? = try container.decodeIfPresent(String.self, forKey: .ingredient4)
        let ingredient5: String? = try container.decodeIfPresent(String.self, forKey: .ingredient5)
        let ingredient6: String? = try container.decodeIfPresent(String.self, forKey: .ingredient6)
        let ingredient7: String? = try container.decodeIfPresent(String.self, forKey: .ingredient7)
        let ingredient8: String? = try container.decodeIfPresent(String.self, forKey: .ingredient8)
        let ingredient9: String? = try container.decodeIfPresent(String.self, forKey: .ingredient9)
        let ingredient10: String? = try container.decodeIfPresent(String.self, forKey: .ingredient10)
        let ingredient11: String? = try container.decodeIfPresent(String.self, forKey: .ingredient11)
        let ingredient12: String? = try container.decodeIfPresent(String.self, forKey: .ingredient12)
        let ingredient13: String? = try container.decodeIfPresent(String.self, forKey: .ingredient13)
        let ingredient14: String? = try container.decodeIfPresent(String.self, forKey: .ingredient14)
        let ingredient15: String? = try container.decodeIfPresent(String.self, forKey: .ingredient15)
        
        return [
            ingredient1,
            ingredient2,
            ingredient3,
            ingredient4,
            ingredient5,
            ingredient6,
            ingredient7,
            ingredient8,
            ingredient9,
            ingredient10,
            ingredient11,
            ingredient12,
            ingredient13,
            ingredient14,
            ingredient15
        ]
    }
    
    private func mapMeasures(for container: KeyedDecodingContainer<CodingKeys>) throws -> [String?] {
        let measure1: String? = try container.decodeIfPresent(String.self, forKey: .measure1)
        let measure2: String? = try container.decodeIfPresent(String.self, forKey: .measure2)
        let measure3: String? = try container.decodeIfPresent(String.self, forKey: .measure3)
        let measure4: String? = try container.decodeIfPresent(String.self, forKey: .measure4)
        let measure5: String? = try container.decodeIfPresent(String.self, forKey: .measure5)
        let measure6: String? = try container.decodeIfPresent(String.self, forKey: .measure6)
        let measure7: String? = try container.decodeIfPresent(String.self, forKey: .measure7)
        let measure8: String? = try container.decodeIfPresent(String.self, forKey: .measure8)
        let measure9: String? = try container.decodeIfPresent(String.self, forKey: .measure9)
        let measure10: String? = try container.decodeIfPresent(String.self, forKey: .measure10)
        let measure11: String? = try container.decodeIfPresent(String.self, forKey: .measure11)
        let measure12: String? = try container.decodeIfPresent(String.self, forKey: .measure12)
        let measure13: String? = try container.decodeIfPresent(String.self, forKey: .measure13)
        let measure14: String? = try container.decodeIfPresent(String.self, forKey: .measure14)
        let measure15: String? = try container.decodeIfPresent(String.self, forKey: .measure15)
        
        return [
            measure1,
            measure2,
            measure3,
            measure4,
            measure5,
            measure6,
            measure7,
            measure8,
            measure9,
            measure10,
            measure11,
            measure12,
            measure13,
            measure14,
            measure15
        ]
    }
}
