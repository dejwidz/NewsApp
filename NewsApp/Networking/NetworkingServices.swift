//
//  NetworkingServices.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 16/07/2022.
//

import Foundation
import UIKit
import Alamofire

final class NetworkingServices {
    
    static var shared = NetworkingServices()
    
    private init () {}
    var articlesToReturn: [Article]?
    
    enum NetworkingErrors: Error {
        case wrongURL
        case wrongRequest
        case wrongDecoding
    }
    
    func getArticlesWithAlamo(completion: @escaping ((Result<News, Error>) -> Void)){
        
        guard let url = URLBuilder.shared.getURLWithoutQuery() else {
            completion(.failure(NetworkingErrors.wrongURL))
            return}
        guard let request = try? URLRequest(url: url, method: .get) else {
            completion(.failure(NetworkingErrors.wrongRequest))
            return
        }
        
        AF.request(request).validate().responseDecodable(of: News.self) {response in
            switch response.result {
            case .success(let news):
                completion(.success(news))
            case .failure(_):
                completion(.failure(NetworkingErrors.wrongDecoding))
            }
        }
    }
    
    
    func getArticlesWithSearch(completion: @escaping ((Result<News, Error>) -> Void)) {
        
        guard let url = URLBuilder.shared.getURLWithQuery() else {
            completion(.failure(NetworkingErrors.wrongURL))
            return
        }
        guard let request = try? URLRequest(url: url, method: .get) else {
            completion(.failure(NetworkingErrors.wrongRequest))
            return
        }
        
        AF.request(request).validate().responseDecodable(of: News.self) { response in
            switch response.result {
            case .failure(_):
                completion(.failure(NetworkingErrors.wrongDecoding))
                break
            case .success(let news):
                completion(.success(news))
                break
            }
        }
    }
    
    func getImageWithAlamo(link: String?, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard let link = link else {
            completion(.failure(NetworkingErrors.wrongURL))
            return
        }
        
        guard let url = URL(string: link) else {
            completion(.failure(NetworkingErrors.wrongURL))
            return
        }
        
        guard let request = try? URLRequest(url: url, method: .get) else {
            completion(.failure(NetworkingErrors.wrongRequest))
            return
        }
        
        AF.request(url ,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData!))
                break
            case .failure(_):
                completion(.failure(NetworkingErrors.wrongDecoding))
            }
        }
    }
    
    func getWeather(completion: @escaping ((Result<Weather, Error>) -> Void)) {
        
        guard let url = URLBuilder.shared.getWeatherURL() else {
            completion(.failure(NetworkingErrors.wrongURL))
            return
        }
        guard let request = try? URLRequest(url: url, method: .get) else {
            completion(.failure(NetworkingErrors.wrongRequest))
            return
        }
        
        AF.request(request).validate().responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .failure(_):
                completion(.failure(NetworkingErrors.wrongDecoding))
                break
            case .success(let weather):
                completion(.success(weather))
                break
            }
        }
    }
    
}
