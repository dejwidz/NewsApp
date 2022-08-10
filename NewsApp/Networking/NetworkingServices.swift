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
    
    static var networkSingleton = NetworkingServices()
    
    private init () {}
    var articlesToReturn: [Article]?
    
    var mainURL = URL(string: "https://newsapi.org/v2/everything?q=null&from=2022-07-10&to=2022-08-06&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683")
    var URLFirstPart = "https://newsapi.org/v2/everything?"
    var queryMark = "q="
    var query = ""
    var fromIndicator = "&from="
    var dateFrom = "2022-07-10"
    var toIndicator = "&to="
    var dateTo = "2022-07-10"
    var URLLastPart = "&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683"
    
//    "https://newsapi.org/v2/top-headlines?country=pl&category=science&pageSize=100&apiKey=715dc191ff584bb2b070568ffb2d6683"
    
//    "https://newsapi.org/v2/everything?q=war&from=2022-07-10&to=2022-07-13&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683"
    
    //    https://newsapi.org/v2/top-headlines?country=pl&apiKey=715dc191ff584bb2b070568ffb2d6683
    
    //    https://newsapi.org/v2/top-headlines?country=pl&category=sports&pageSize=100&apiKey=715dc191ff584bb2b070568ffb2d6683
    
    //https://newsapi.org/v2/top-headlines?country=pl&apiKey=715dc191ff584bb2b070568ffb2d6683
    
    //https://newsapi.org/v2/everything?q=apple&from=2022-07-08&to=2022-07-08&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683
    //
    
    enum NetworkingErrors: Error {
        case wrongURL
        case wrongRequest
        case wrongDecoding
    }
    
    
    func getArticlesWithAlamo(completion: @escaping ((Result<News, Error>) -> Void)){
        
        guard let url = URLBuilder.shared.getURLWithoutQuery() else {
            completion(.failure(NetworkingErrors.wrongURL))
            print("chuj nie url")
            return}
        
        guard let request = try? URLRequest(url: url, method: .get) else {
            completion(.failure(NetworkingErrors.wrongRequest))
            print("chuj nie request")
            return
        }
        
        AF.request(request).validate().responseDecodable(of: News.self) {response in
            switch response.result {
            case .success(let news):
                completion(.success(news))
            case .failure(let error):
                print("chuj nie cośtam")
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
            case .failure(let error):
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
            print("CHUJ link")
            return
        }
        
        guard let url = URL(string: link) else {
            completion(.failure(NetworkingErrors.wrongURL))
            print("CHUJ url")
            return
        }
        
        guard let request = try? URLRequest(url: url, method: .get) else {
            completion(.failure(NetworkingErrors.wrongRequest))
            print("CHUJ reques")
            return
        }
        
        AF.request(url ,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData!))
                break
            case .failure(let error):
                print("CHUJJ AF")
                completion(.failure(NetworkingErrors.wrongDecoding))
            }
        }
        
    }
    
    
    
    
}
