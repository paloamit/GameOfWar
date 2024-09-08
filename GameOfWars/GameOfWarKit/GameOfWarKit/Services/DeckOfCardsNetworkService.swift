//
//  DeckOfCardsNetworkService.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://deckofcardsapi.com/api/deck"
}

protocol DeckOfCardsNetworkServiceContract {
    func shuffleNewDeckOfCards(deckCount: Int,
                               completion: @escaping (Result<DeckResponse, Error>) -> Void)
    func shuffleExistingDeckOfCards(deckId: String,
                                    completion: @escaping (Result<DeckResponse, Error>) -> Void)
    func drawCards(deckId: String,
                   completion: @escaping (Result<DrawCardsResponse, Error>) -> Void)
    func addToPile(deckId: String,
                   pileName: String,
                   cards: String,
                   completion: @escaping (Result<DeckResponse, Error>) -> Void)
    func shufflePile(deckId: String,
                     pileName: String,
                     completion: @escaping (Result<DeckResponse, Error>) -> Void)
    func listCardsInPile(deckId: String,
                         pileName: String,
                         completion: @escaping (Result<ListPileResponse, Error>) -> Void)
    func drawCardsFromPile(deckId: String,
                           pileName: String,
                           count: Int,
                           cards: String?,
                           completion: @escaping (Result<DrawCardsResponse, Error>) -> Void)
}

final class DeckOfCardsNetworkService: DeckOfCardsNetworkServiceContract {
    
    private let networkService: any NetworkServiceContract
    
    init(networkService: any NetworkServiceContract) {
        self.networkService = networkService
    }
    
    func shuffleNewDeckOfCards(deckCount: Int = 1,
                               completion: @escaping (Result<DeckResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/new/shuffle/?deck_count=\(deckCount)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DeckOfCardsAPIError.invalidURL))
            return
        }
        
        networkService.performRequest(url: url, completion: completion)
    }
    
    func shuffleExistingDeckOfCards(deckId: String,
                                    completion: @escaping (Result<DeckResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/\(deckId)/shuffle/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DeckOfCardsAPIError.invalidURL))
            return
        }
        
        networkService.performRequest(url: url, completion: completion)
    }
    
    func drawCards(deckId: String,
                   completion: @escaping (Result<DrawCardsResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/\(deckId)/draw/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DeckOfCardsAPIError.invalidURL))
            return
        }
        
        networkService.performRequest(url: url, completion: completion)
    }
    
    func addToPile(deckId: String,
                   pileName: String,
                   cards: String,
                   completion: @escaping (Result<DeckResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/\(deckId)/pile/\(pileName)/add/?cards=\(cards)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DeckOfCardsAPIError.invalidURL))
            return
        }
        
        networkService.performRequest(url: url, completion: completion)
    }
    
    func shufflePile(deckId: String,
                     pileName: String,
                     completion: @escaping (Result<DeckResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/\(deckId)/pile/\(pileName)/shuffle/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DeckOfCardsAPIError.invalidURL))
            return
        }
        
        networkService.performRequest(url: url, completion: completion)
    }
    
    func listCardsInPile(deckId: String,
                         pileName: String,
                         completion: @escaping (Result<ListPileResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/\(deckId)/pile/\(pileName)/list/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DeckOfCardsAPIError.invalidURL))
            return
        }
        
        networkService.performRequest(url: url, completion: completion)
    }
    
    func drawCardsFromPile(deckId: String,
                           pileName: String,
                           count: Int,
                           cards: String?,
                           completion: @escaping (Result<DrawCardsResponse, Error>) -> Void) {
        var urlString = "\(APIConstants.baseURL)/\(deckId)/draw/?count=\(count)"
        if let cards {
            urlString.append("&cards=\(cards)")
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DeckOfCardsAPIError.invalidURL))
            return
        }
        
        networkService.performRequest(url: url, completion: completion)
    }
}
