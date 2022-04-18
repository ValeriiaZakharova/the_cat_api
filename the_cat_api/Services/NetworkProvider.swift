//
//  NetworkProvider.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 25.03.2022.
//

import UIKit

enum NetworkError: String, Error {
    case invalidRequest
    case invalidResponse
    case invalidData
}

protocol CategoriesService {
    func fetchCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void)

    func fetchBreeds(completion: @escaping (Result<[Breed], NetworkError>) -> Void)

    func fetchCategory(categoryId: Int, completion: @escaping (Result<[Cats], NetworkError>) -> Void)
}

protocol ImageService {
    func downloadImage(from urlString: String, complition: @escaping (UIImage?) -> Void)
}

final class NetworkProvider: CategoriesService, ImageService {

    let cache = NSCache<NSString, UIImage>()

    let callbackQueue: DispatchQueue

    private let apiKey = "98b10711-58bd-4a27-a3e3-ff975e8869fe"
    private let baseUrl = "https://api.thecatapi.com/v1/"

    init(callbackQueue: DispatchQueue = .main) {
        self.callbackQueue = callbackQueue
    }

    func fetchCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {

        guard let url = URL(string: "\(baseUrl)categories?api_key=\(apiKey)") else { return }

        //wraps completion to the main queue
        let callback: (Result<[Category], NetworkError>) -> Void = { [callbackQueue] result in
            callbackQueue.async { completion(result) }
        }

        let session = URLSession.shared

        session.dataTask(with: url) { data, response, error in
            if let response = response {
                callback(.failure(.invalidResponse))
                print(response)
            }
            
            guard let data = data else {
                callback(.failure(.invalidResponse))
                return
            }

            do {
                let result = try JSONDecoder().decode([Category].self, from: data)
                callback(.success(result))
            } catch {
                callback(.failure(.invalidData))
            }
        }
        .resume()
    }

    func fetchBreeds(completion: @escaping (Result<[Breed], NetworkError>) -> Void) {
        let session = URLSession.shared

        guard let url = URL(string: "\(baseUrl)breeds?api_key=\(apiKey)") else { return }

        let callback: (Result<[Breed], NetworkError>) -> Void = { [callbackQueue] result in
            callbackQueue.async { completion(result) }
        }

        session.dataTask(with: url) { data, response, error in
            if let response = response {
                callback(.failure(.invalidResponse))
                print(response)
            }

            guard let data = data else {
                callback(.failure(.invalidResponse))
                return
            }

            do {
                let result = try JSONDecoder().decode([Breed].self, from: data)
                callback(.success(result))
            } catch {
                callback(.failure(.invalidData))
            }
        }
        .resume()
    }

    func fetchCategory(categoryId: Int, completion: @escaping (Result<[Cats], NetworkError>) -> Void) {
        let session = URLSession.shared

        guard let url = URL(string: "\(baseUrl)images/search?api_key=\(apiKey)&category_ids=\(categoryId)&limit=100") else { return }

        let callback: (Result<[Cats], NetworkError>) -> Void = { [callbackQueue] result in
            callbackQueue.async { completion(result) }
        }

        session.dataTask(with: url) { data, response, error in

            if let response = response {
                callback(.failure(.invalidResponse))
                print(response)
            }

            guard let data = data else {
                callback(.failure(.invalidResponse))
                return
            }

            do {
                let result = try JSONDecoder().decode([Cats].self, from: data)
                callback(.success(result))
            } catch {
                callback(.failure(.invalidData))
            }
        }.resume()
    }

    func downloadImage(from urlString: String, complition: @escaping (UIImage?) -> Void) {

        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            complition(image)
            return
        }

        guard let url = URL(string: urlString) else {
            complition(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                complition(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            complition(image)
        }
        task.resume()
    }
}
