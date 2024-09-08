//
//  Card.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

public struct Card: Decodable {
    let code: String
    let image: String
    let value: String
    let suit: String
}
