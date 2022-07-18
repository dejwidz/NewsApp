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
     var mainURL = URL(string: "https://newsapi.org/v2/everything?q=war&from=2022-07-10&to=2022-07-18&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683")
    
     var URLPart1 = "https://newsapi.org/v2/everything?"
    var queryMark = "q="
    var query = ""
    var URLPart2 = "&from=2022-07-10&to=2022-07-10&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683"
    
//    https://newsapi.org/v2/top-headlines?country=pl&apiKey=715dc191ff584bb2b070568ffb2d6683
    
//    https://newsapi.org/v2/top-headlines?country=pl&category=sports&apiKey=715dc191ff584bb2b070568ffb2d6683
    
//https://newsapi.org/v2/top-headlines?country=pl&apiKey=715dc191ff584bb2b070568ffb2d6683
    
//https://newsapi.org/v2/everything?q=apple&from=2022-07-08&to=2022-07-08&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683
//
    
    enum NetworkingErrors: Error {
        case wrongURL
        case wrongRequest
        case wrongDecoding
    }
    
    
    func downloadData(completion: @escaping ((Result<[Article], Error>) -> Void)) {
        guard let url = mainURL else {return}
        
        let task = URLSession.shared.dataTask(with: url) {data, response, error  in
            if let error = error {
                completion(.failure(NetworkingErrors.wrongRequest))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(News.self, from: data)
                    completion(.success(result.articles ?? []))
                    print("ilość artykułów w result: \(result.articles?.count)"  )
                }
                catch {
                    completion(.failure(NetworkingErrors.wrongDecoding))
                }
            }
            
            
        }
        task.resume()
    }
    
    func getImage(link: String?, completion: @escaping ((Result<Data, Error>) -> Void)) {
       
        guard let link = link else {return}
        
        guard let url = URL(string: link) else {return}

        let session = URLSession.shared.dataTask(with: url) {data, _, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return}
            
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))

        }
        session.resume()
        }
            
    func getArticlesWithAlamo(completion: @escaping ((Result<News, Error>) -> Void)){
        
        guard let url = NetworkingServices.networkSingleton.mainURL else {
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
            case .failure(let error):
                completion(.failure(NetworkingErrors.wrongDecoding))
            }
        }
    }

    
    func getArticlesWithSearch(query: String, completion: @escaping ((Result<News, Error>) -> Void)) {
        self.query = query
        var searchStringUrl = URLPart1 + queryMark + query + URLPart2
        guard let url = URL(string: searchStringUrl) else {
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
        
//        AF.request(request).validate().responseDecodable(of: Data.self) { response in
//            switch response.result {
//            case .failure(let error):
//                print("CHUJ AF")
//                completion(.failure(NetworkingErrors.wrongDecoding))
//                break
//            case .success(let data):
//                completion(.success(data))
//                break
//            }
//        }
        
        AF.request(url ,method: .get).response{ response in
           switch response.result {
            case .success(let responseData):
//                self.myImageView.image = UIImage(data: responseData!, scale:1)
               completion(.success(responseData!))

            case .failure(let error):
                print("CHUJJ AF")
               completion(.failure(NetworkingErrors.wrongDecoding))
            }
        }
        
    }
    
    
    
    
}
