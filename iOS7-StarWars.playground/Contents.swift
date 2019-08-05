import UIKit

// https://swapi.co/api/people/1/

struct Person: Codable {
    let name: String
    let height: Int // Int vs. String
    let hairColor: String // hair_color vs. hairColor

    let films: [URL]
    let vehicles: [URL]
    let starships: [URL]
    
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
        
        // Back up decoding method if the types don't match
//        if let heightString = try? container.decode(String.self, forKey: .height) {
//            self.height = Int(heightString) ?? 0
//        } else if let height = try? container.decode(Int.self, forKey: .height) {
//            self.height = height
//        } else {
//            self.height = 0
//        }
        
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
        
        // 2nd approach: map
        
        let vehicleStrings = try container.decode([String].self, forKey: .vehicles)
        vehicles = vehicleStrings.compactMap { URL(string: $0) }
        
        // 3rd approach: [URL].self
        starships = try container.decode([URL].self, forKey: .starships)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PersonKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(String(height), forKey: .height)
        try container.encode(hairColor, forKey: .hairColor)
        
        // 1st approach
        var filmsContainer = container.nestedUnkeyedContainer(forKey: .films)
        for filmURL in films {
            try filmsContainer.encode(filmURL.absoluteString)
        }
        
        // 2nd approach
        let vehicleStrings = vehicles.map { $0.absoluteString }
        try container.encode(vehicleStrings, forKey: .vehicles)
        
        // 3rd approach
        try container.encode(starships, forKey: .starships)
    }
    
    
}

// Prototyping code: please handle errors in a real app
let url = URL(string: "https://swapi.co/api/people/1/")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let luke = try! decoder.decode(Person.self, from: data)
print(luke)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let lukeData = try! encoder.encode(luke)

// print out data as Sting
let lukeString = String(data: lukeData, encoding: .utf8)
print(lukeString!)

let testLuke = try! decoder.decode(Person.self, from: lukeData)
print(testLuke)



let plistEncoder = PropertyListEncoder()
plistEncoder.outputFormat = .xml // .binary // .xml

let plistData = try plistEncoder.encode(luke)

// Print .binary data using NSData in a print
//let newData = NSData(data: plistData)
//print(newData)

let plistString = String(data: plistData, encoding: .utf8)!
print(plistString)

//plistData.write(to: <#T##URL#>) // save to disk
