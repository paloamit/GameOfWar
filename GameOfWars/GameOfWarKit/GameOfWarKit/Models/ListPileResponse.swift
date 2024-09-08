//
//  ListPileResponse.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

struct ListPileResponse: Decodable {
    let success: Bool
    let deckId: String
    let piles: [String: PileDetails]
    
    private enum CodingKeys: String, CodingKey {
        case success
        case deckId = "deck_id"
        case piles
    }
}
