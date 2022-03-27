//
//  NetworkProvider.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 25.03.2022.
//

import UIKit

protocol CategoriesService {
    func fetchCategories(completion: @escaping ([Category], Error?) -> Void)

    func fetchCategory(category_ids: Category, completion: @escaping ([Cats], Error?) -> Void)
}

protocol ImageService {
    func downloadImage(from urlString: String, complition: @escaping (UIImage?) -> Void)
}

final class NetworkProvider: CategoriesService, ImageService {

    static let shared = NetworkProvider()

    private let apiKey = "98b10711-58bd-4a27-a3e3-ff975e8869fe"
    private let baseUrl = "https://api.thecatapi.com/v1/"

    func fetchCategories(completion: @escaping ([Category], Error?) -> Void) {

        guard let url = URL(string: "\(baseUrl)categories?api_key=\(apiKey)") else { return }

        let session = URLSession.shared

        session.dataTask(with: url) { data, response, error in
            if let response = response {
                print(response)
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }

            do {
                let result = try JSONDecoder().decode([Category].self, from: data)
                DispatchQueue.main.async {
                    completion(result, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], `error`)
                }
            }
        }
        .resume()
    }

    func fetchCategory(category_ids: Category, completion: @escaping ([Cats], Error?) -> Void) {
        let session = URLSession.shared

        let param = category_ids.id

        guard let url = URL(string: "\(baseUrl)images/search?api_key=\(apiKey)&category_ids=\(param)&limit=100") else { return }

        session.dataTask(with: url) { data, response, error in

            if let response = response {
                print(response)
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }

            do {
                let result = try JSONDecoder().decode([Cats].self, from: data)
                DispatchQueue.main.async {
                    completion(result, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }.resume()
    }

    func downloadImage(from urlString: String, complition: @escaping (UIImage?) -> Void) {

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
            complition(image)
        }
        task.resume()
    }
}
