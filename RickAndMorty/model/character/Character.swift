import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let image: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let episode: [String]
}
