struct AlcoholicTypeFilterDTO {
    let alcoholicType: String
    
    enum CodingKeys: String, CodingKey {
        case alcoholicType = "strAlcoholic"
    }
}

extension AlcoholicTypeFilterDTO: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alcoholicType = try container.decode(String.self, forKey: .alcoholicType)
    }
}
