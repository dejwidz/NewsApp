//
//  DataStorage.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 24/07/2022.
//

import Foundation
import RealmSwift

class DataStorage {
    
    static var shared = DataStorage()
    private var storedArticles = try! Realm()
    
    private init() {}
    
    func addUserChoiceArticle(newArticle: Article) {
        let newUserChoiceArticle = UserChoiceArticle(newArticle: newArticle)
        try! storedArticles.write {
            storedArticles.add(newUserChoiceArticle)
        }
    }
    
    func getUserChoiceArticles() -> [UserChoiceArticle] {
        let userChoiceArticles = storedArticles.objects(UserChoiceArticle.self)
        var articlesToReturn: [UserChoiceArticle] = []
        for i in userChoiceArticles {
            articlesToReturn.append(i)
        }
        return articlesToReturn
    }
    
    func deleteArticleFromUserChoice(articleToDelete: UserChoiceArticle) {
        try! storedArticles.write {
            storedArticles.delete(articleToDelete)
        }
    }
    
    func setLatestArticles(latestArticles: [Article]) {
        deleteLatestArticles()
        for i in latestArticles {
            let latestArticle = LatestArticle(newArticle: i)
            try! storedArticles.write({
                storedArticles.add(latestArticle)
            })
        }
    }
    
    func getLatestArticles() -> [Article] {
        let articles = storedArticles.objects(LatestArticle.self)
        var articlesToReturn: [Article] = []
        for i in articles {
            let nextArticle = Article(newArticle: i)
            articlesToReturn.append(nextArticle)
        }
        return articlesToReturn
    }
    
    func deleteLatestArticles() {
        try! storedArticles.write({
            let latestArticles = storedArticles.objects(LatestArticle.self)
            storedArticles.delete(latestArticles)
        })
    }
}

