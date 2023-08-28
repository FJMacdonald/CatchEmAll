//
//  CreaturesDetailViewModel.swift
//  CatchEmAll
//
//  Created by Francesca MACDONALD on 2023-08-27.
//

import Foundation
@MainActor
class CreaturesDetailViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var height: Double?
        var weight: Double?
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var front_default: String?
        var other: Other
    }
    // Use CodingKeys to map JSON keys to Swift variables.
    // The Swift variable name is the case, which should be set equal to
    // the string that is iddentical to the JSON Key name.
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Codable {
        var front_default: String?
    }
    
    @Published var urlString = ""
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL = ""
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our data structure
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not deccode returned JSON data")
                return
            }
            self.height = returned.height ?? 0.0
            self.weight = returned.weight ?? 0.0
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "n/a"
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
    
}
