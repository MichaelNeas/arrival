//
//  MBTAAPI.swift
//  Arrival
//
//  Created by Michael Neas on 4/11/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import Foundation

class MBTAAPI {
    
    public static let shared = MBTAAPI()
    
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://api-v3.mbta.com/stops?filter[route]=222")!
    private let apiKey = "dc9a721a7abf494191c427544d76b986"
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    public func fetchStops(result: @escaping (Result<Stops, APIServiceError>) -> Void) {
        fetchResources(url: baseURL, completion: result)
    }
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        urlComponents.queryItems = queryItems
        
//        guard let url = urlComponents.url else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(.apiError))
            }
        }.resume()
    }
}
