struct FilteredListItemDTO: Decodable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
    }
}
