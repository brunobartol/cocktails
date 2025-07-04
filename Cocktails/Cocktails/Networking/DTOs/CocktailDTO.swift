struct CocktailDTO {
    let id: String
    let name: String
    let category: String
    let alcoholic: String
    let imageUrl: String
    var ingredients: String?
    
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
        self.ingredients = try mapIngredients(for: container)
    }
    
    private func mapIngredients(for container: KeyedDecodingContainer<CodingKeys>) throws -> String {
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
        
        let allIngredients = [
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
        ].compactMap { $0 }
        
        return allIngredients.joined(separator: ", ")
    }
}
