//
//  GameError.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 08/09/24.
//

import Foundation

public enum GameError: Error {
    case gameOver(winnerIndex: Int)
}
