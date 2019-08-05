import UIKit

// https://swapi.co/api/people/1/

struct Person: Codable {
    let name: String
    let height: Int // Int vs. String
    let hairColor: String // hair_color vs. hairColor

    let films: [URL]
//    let vehicles: [URL]
//    let starships: [URL]
    
    enum PersonKeys: String, CodingKey {
        case name
        case height // We can rename variables: = "height_in_meters"
        case hairColor = "hair_color"
        case films
        case vehicles
        case starships
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        let heightString = try container.decode(String.self, forKey: .height)
        height = Int(heightString) ?? 0
        
        hairColor = try container.decode(String.self, forKey: .hairColor)
        
        var filmsContainer = try container.nestedUnkeyedContainer(forKey: .films)
        
        // 1st approach using a while loop
        var filmURLs: [URL] = []
        while filmsContainer.isAtEnd == false {
            let filmString = try filmsContainer.decode(String.self)
            if let url = URL(string: filmString) {
                filmURLs.append(url)
            }
        }
        films = filmURLs
    }
    
}

// Prototyping code: please handle errors in a real app
let url = URL(string: "https://swapi.co/api/people/1/")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let luke = try! decoder.decode(Person.self, from: data)
print(luke)
