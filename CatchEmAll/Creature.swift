//
//  Creature.swift
//  CatchEmAll
//
//  Created by Francesca MACDONALD on 2023-08-27.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString
    
    var name: String
    var url: String
    
    //CodingKeys will let you speciffy which properties should be used ffor coding and decoding.  Create a CodingKeys enum, but leave a property off the case list, and that property won't be used for coding and decoding
    //Using CodingKeys gets rid of the warning "Immutable property will not be decoded because it is declared with an initial value which cannot be overwritten"
    enum CodingKeys: CodingKey {
        case name
        case url
    }
}

