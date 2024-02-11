//
//  APIManager.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import Foundation

enum Errors: Error {
    case failedRequest
    case emptyData
    case wrongData
    case invalidResponse
    case invalidData
}

class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func fetchWeather<T: Decodable>(type: T.Type, api: WeatherAPI, url: URL, completionHandler: @escaping ((T?, Errors?) -> Void)) {
        var url: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async() {
                
                guard error == nil else {
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, .emptyData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(result, nil)
                    
                } catch {
                    print("Decoding error: \(error)")
                    completionHandler(nil, .wrongData)
                }
            }
        }
        .resume()
    }
}
