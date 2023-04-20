//
//  NetworkingServices.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 16/07/2022.
//

import Foundation
import UIKit
import Alamofire

protocol NetDataSupplier {
    func getImage(link: String?, completion: @escaping ((Result<Data, Error>) -> Void))
    func getDataFromWeb<T: Decodable>(typename: T, completion: @escaping ((Result<T, Error>) -> Void))
}

final class NetworkingServices: NetDataSupplier {
    
    static var shared = NetworkingServices()
    private init () {}
    
    enum NetworkingErrors: Error {
        case wrongURL
        case wrongRequest
        case wrongDecoding
    }
    
    func getImage(link: String?, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard let link = link else {
            completion(.failure(NetworkingErrors.wrongURL))
            return
        }
        
        guard let url = URL(string: link) else {
            completion(.failure(NetworkingErrors.wrongURL))
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
    
    private func prepareRequest() -> URLRequest? {
        guard let url = URLBuilder.shared.getURL() else {
            return nil
        }
        guard let request = try? URLRequest(url: url, method: .get) else {
            return nil
        }
        return request
    }
    
    func getDataFromWeb<T: Decodable>(typename: T, completion: @escaping ((Result<T, Error>) -> Void)) {
        guard let request = prepareRequest() else {
            completion(.failure(NetworkingErrors.wrongRequest))
            return
        }
        AF.request(request).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(NetworkingErrors.wrongDecoding))
                print(#function, error.localizedDescription)
                break
            case .success(let data):
                completion(.success(data))
                break
            }
        }
    }
}
