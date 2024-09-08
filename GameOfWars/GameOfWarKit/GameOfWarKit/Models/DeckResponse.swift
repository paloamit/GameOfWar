//
//  DeckResponse.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

struct DeckResponse: Decodable {
    let success: Bool
    let deckId: String
    let shuffled: Bool
    let remaining: Int
    
    private enum CodingKeys: String, CodingKey {
        case success
        case deckId = "deck_id"
        case shuffled
        case remaining
    }
}
