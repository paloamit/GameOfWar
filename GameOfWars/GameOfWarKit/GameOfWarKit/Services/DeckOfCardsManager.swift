//
//  DeckOfCardsManager.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

public protocol DeckOfCardsManagerContact {
    func setupGame(numberOfPlayers: Int,
                   completion: @escaping (Result<Void, Error>) -> Void)
    func playRound(completion: @escaping (Result<RoundResult, GameError>) -> Void)
    func resetGame(completion: @escaping (Result<Void, Error>) -> Void)
}

public final class DeckOfCardsManager: DeckOfCardsManagerContact {
    private let networkService: DeckOfCardsNetworkServiceContract
    private var players: [[Card]] = []
    private var battleCounters: [Int] = []
    private var deckID: String = ""
    private var numberOfPlayers: Int = 2
    private let pileName = "players"
    
    public static let shared = DeckOfCardsManager()
    
    init() {
        self.networkService = DeckOfCardsNetworkService(networkService: NetworkService())
    }
    
    public func setupGame(numberOfPlayers: Int,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        self.numberOfPlayers = numberOfPlayers
        networkService.shuffleNewDeckOfCards(deckCount: 1, completion: { [weak self] result in
            switch result {
            case .success(let deck):
                self?.deckID = deck.deckId
                self?.drawCardsForPlayers(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public func playRound(completion: @escaping (Result<RoundResult, GameError>) -> Void) {
        var playedCards: [Card] = []
        for i in 0..<numberOfPlayers {
            if let card = players[i].randomElement() {
                playedCards.append(card)
            }
        }
        
        let winnerIndex = determineWinner(from: playedCards)
        print(winnerIndex)
        battleCounters[winnerIndex] += 1
        
        if battleCounters[winnerIndex] >= 10  {
            print(battleCounters)
            completion(.failure(GameError.gameOver(winnerIndex: winnerIndex)))
        } else {
            completion(.success(RoundResult(winnerIndex: winnerIndex, cardsInPlay: playedCards)))
        }
    }
    
    public func resetGame(completion: @escaping (Result<Void, Error>) -> Void) {
        players.removeAll()
        battleCounters.removeAll()
        setupGame(numberOfPlayers: numberOfPlayers, completion: completion)
    }
}

private extension DeckOfCardsManager {
    func cardValue(_ card: Card) -> Int {
        switch card.value {
        case "ACE": return 14
        case "KING": return 13
        case "QUEEN": return 12
        case "JACK": return 11
        default: return Int(card.value) ?? 0
        }
    }
    
    func determineWinner(from cards: [Card]) -> Int {
        let values = cards.map { cardValue($0) }
        let highestValue = values.max()
        let winners = values.enumerated().filter { $0.element == highestValue }.map { $0.offset }
        if winners.count == 1 {
            return winners[0]
        } else {
            let playerCardCounts = winners.map { players[$0].count }
            let maxCardCount = playerCardCounts.max()
            let cardCountWinners = winners.filter { players[$0].count == maxCardCount }
            if cardCountWinners.count == 1 {
                return cardCountWinners[0]
            } else {
                return cardCountWinners.randomElement()!
            }
        }
    }
    
    func drawCardsForPlayers(completion: @escaping (Result<Void, Error>) -> Void) {
        networkService.drawCardsFromPile(deckId: deckID, pileName: pileName, count: 52, cards: nil) { [weak self] result in
            switch result {
            case .success(let drawCardsResponse):
                self?.players = Array(repeating: [], count: self?.numberOfPlayers ?? 2)
                for i in 0..<drawCardsResponse.cards.count {
                    self?.players[i % (self?.numberOfPlayers ?? 2)].append(drawCardsResponse.cards[i])
                }
                self?.battleCounters = Array(repeating: 0, count: self?.numberOfPlayers ?? 2)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
