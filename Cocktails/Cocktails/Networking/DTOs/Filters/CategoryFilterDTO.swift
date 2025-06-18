struct CategoryFilterDTO {
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case category = "strCategory"
    }
}

extension CategoryFilterDTO: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(String.self, forKey: .category)
    }
}
