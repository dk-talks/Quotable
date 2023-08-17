//
//  Data.swift
//  Quotable
//
//  Created by Dinesh Sharma on 12/08/23.
//

import Foundation
import UIKit

class APIClient {
    
    static func fetchData(_ completion: @escaping (Result<[Country], Error>) -> Void) {
        
        let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,idd,flags,altSpellings")
        var parsedData: [Country] = []
        
        let newTask = URLSession.shared.dataTask(with: url!) { countryData, res, error in
            
            
            if let err = error {
                print("some error occured in fetching data: \(err)")
                completion(.failure(err))
                return
            }
            
            if let httpResponse = res as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    if let safeData = countryData {
                        
                        let decoder = JSONDecoder()
                        do {
                            parsedData = try decoder.decode([Country].self, from: safeData)
                            completion(.success(parsedData))
                        } catch {
                            print("some exception occured: \(error)")
                            completion(.failure(error))
                        }
                        
                    }
                    
                } else {
                    print("response is not right: \(httpResponse.statusCode)")
                    
                }
            }
            
        }
        newTask.resume()
    }
    
    static func urlToImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        let newTask = URLSession.shared.dataTask(with: url) { imageData, imgRes, err in
            
            if let err = err {
                print("some error in fetching image from url: \(err)")
                completion(.failure(err))
                return
            }
            
            if let data = imageData {
                completion(.success(UIImage(data: data)!))
            }
            
        }
        newTask.resume()
        
    }
    
}
