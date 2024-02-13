//
//  IconAPIManager.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/13/24.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(nil, Errors.invalidData)
                    return
                }
                
                completion(image, nil)
            }
        }.resume()
    }
}
