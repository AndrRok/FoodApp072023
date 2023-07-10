//
//  NetworkManager.swift
//  FoodApp
//
//  Created by ARMBP on 7/3/23.
//

import UIKit


class NetworkManager {
    static let shared           = NetworkManager()
    private let mainURL       = "https://run.mocky.io/v3/058729bd-1402-4578-88de-265481fd7d54"
   private let dishesURL    = "https://run.mocky.io/v3/aba7ecaa-0a70-453b-b62d-0e326c859b3b"
    
    private init() {}
    
    func getMainRequest(completed: @escaping (Result< FoodItemResponse, ErrorMessages>) -> Void) {
        let endpoint = mainURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                let resultFoodItems            = try decoder.decode(FoodItemResponse.self, from: data)
                completed(.success(resultFoodItems))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getDishesRequest(completed: @escaping (Result<DishesResponse, ErrorMessages>) -> Void) {
        let endpoint = dishesURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                let resultDishes        = try decoder.decode(DishesResponse.self, from: data)
                completed(.success(resultDishes))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    //MARK: - DownLoad image
    func downloadImage(from urlString: String, completed: @escaping(UIImage?)-> Void){
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            completed(image)
        }
        task.resume()
    }
}

