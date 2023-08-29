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
    
    static func fetchQuoteImage(_ completion: @escaping (Result<QuoteImage, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.pexels.com/v1/search?query=nature")!,timeoutInterval: Double.infinity)
        request.addValue("5fAmFQwGmSJR64T7exoWMK0xLqD5xulyXXJRd5TvzQGt0WAu3rRqaodf", forHTTPHeaderField: "Authorization")
        request.addValue("__cf_bm=HvgOEpt6hXHOQVUxm4idzCfB2mG02gxZZJTD8qG4z.8-1692852563-0-ATa9MyFwJnJ7PDLiFg2I3ognl7+x8sOpPVv5O0pMwWmMcTWR4mHHPVNPBRHTQPZoqDY2uNUFqfJ2L+nQZrL12Bo=", forHTTPHeaderField: "Cookie")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
              if let error = error {
                  completion(.failure(error))
              }
            return
          }
          let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(QuoteImage.self, from: data)
                completion(.success(decodedData))
                
            } catch {
                print("error in decoding quote iamge data: \(error)")
            }
        }

        task.resume()

    }
    
    static func fetchQuote() async -> [Quote] {
        var quotes: [Quote] = []
        let url = URL(string: "https://api.quotable.io/quotes/random?limit=15,tags=nature")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url!)
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200) {
                    let decoder = JSONDecoder()
                    quotes = try decoder.decode([Quote].self, from: data)
                    return quotes
                }
            }
            
        } catch(let error) {
            print("An Error in fetching data from API: \(error)")
        }
        
        return quotes
    }
    
    
    
}
