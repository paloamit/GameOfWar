//
//  DrawCardsResponse.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

struct DrawCardsResponse: Decodable {
    let success: Bool
    let cards: [Card]
    let deckId: String
    let remaining: Int
    let shuffled: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case success
        case cards
        case deckId = "deck_id"
        case remaining
        case shuffled
    }
}
