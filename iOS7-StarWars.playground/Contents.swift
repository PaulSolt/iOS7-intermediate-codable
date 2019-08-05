import UIKit

// https://swapi.co/api/people/1/

struct Person: Codable {
    let name: String
    let height: Int // Int vs. String
    let hairColor: String // hair_color vs. hairColor
    
    let films: [URL]
    let vehicles: [URL]
    let starships: [URL]
    
    init(from decoder: Decoder) throws {
        
    }
    
}

// Prototyping code: please handle errors in a real app
let url = URL(string: "https://swapi.co/api/people/1/")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let luke = try! decoder.decode(Person.self, from: data)
print(luke)
