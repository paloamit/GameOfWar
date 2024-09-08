//
//  PileDetails.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

struct PileDetails: Decodable {
    let remaining: Int
    let cards: [Card]
}
