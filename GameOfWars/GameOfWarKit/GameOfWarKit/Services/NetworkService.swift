//
//  NetworkService.swift
//  GameOfWarKit
//
//  Created by Amit Palo on 07/09/24.
//

import Foundation

protocol NetworkServiceContract {
    associatedtype T = Decodable
    func performRequest<T: Decodable>(url: URL, 
                                      completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: NetworkServiceContract {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(DeckOfCardsAPIError.requestFailed))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(DeckOfCardsAPIError.invalidResponse))
            }
        }
        task.resume()
    }
}
