//
//  Model.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import Foundation


protocol FirstModelProtocol: AnyObject {
    var delegate:FirstModelDelegate? {get set}
    func getAriclesFromWeb()
}

protocol FirstModelDelegate: AnyObject {
    func articlesHasBeenDownloaded(_ firstModel: FirstModelProtocol, articles: [Article])
    func errorWhileDownloadingArticles(_ firstModel: FirstModelProtocol)
}

final class FirstModel: FirstModelProtocol {
   
    
        
    weak var delegate: FirstModelDelegate?
    
    
    init() {
        
    }
    
    func getAriclesFromWeb() {
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^%%^^^^^^")
        NetworkingServices.networkSingleton.getArticlesWithAlamo(completion: {[weak self] result in
            switch result {
                
            case .success(let news):
                print("------------------------------ SUCCES")
                self!.delegate?.articlesHasBeenDownloaded(self!, articles: news.articles!)
            case .failure(let error):
                self!.delegate?.errorWhileDownloadingArticles(self!)
                print(error.localizedDescription)
            }
        })
    }
   

}
