struct GlassFilterDTO {
    let glass: String
    
    enum CodingKeys: String, CodingKey {
        case glass = "strGlass"
    }
}

extension GlassFilterDTO: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.glass = try container.decode(String.self, forKey: .glass)
    }
}
