//
//  DataStorage.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 24/07/2022.
//

import Foundation
import RealmSwift
import CoreLocation

protocol UserChoiceArticlesManager {
    func addUserChoiceArticle(newArticle: Article)
    func getUserChoiceArticles() -> [UserChoiceArticle]
    func deleteArticleFromUserChoice(articleToDelete: UserChoiceArticle)
}

protocol LatestArticlesManager {
    func setLatestArticles(latestArticles: [Article])
    func getLatestArticles() -> [Article]
    func deleteLatestArticles()
}

protocol LocationManager {
    func setLastLocation(newLocation: CLLocation)
    func setFirstLocation(_ firstLocation: CLLocation)
    func getLastLocationLatitude() -> String
    func getLastLocationLongitude() -> String
}

final class DataStorage: UserChoiceArticlesManager, LatestArticlesManager, LocationManager {
    
    static var shared = DataStorage()
    private var storedInformation = try! Realm()
    
    private init() {}
    
    func addUserChoiceArticle(newArticle: Article) {
        guard articleHasNotBeenAddedYet(newArticle: newArticle) else { return }
        let newUserChoiceArticle = UserChoiceArticle(newArticle: newArticle)
        do {
            try storedInformation.write {
                storedInformation.add(newUserChoiceArticle)
            }
        }
        catch {}
    }
    
    private func articleHasNotBeenAddedYet(newArticle: Article) -> Bool {
        var articleHasNotBeenAddedYet = true
        let userChoiceArticles = storedInformation.objects(UserChoiceArticle.self)
        for article in userChoiceArticles {
            if article.url == newArticle.url {
                articleHasNotBeenAddedYet = false
                break
            }
        }
        return articleHasNotBeenAddedYet
    }
    
    func getUserChoiceArticles() -> [UserChoiceArticle] {
        let userChoiceArticles = storedInformation.objects(UserChoiceArticle.self)
        var articlesToReturn: [UserChoiceArticle] = []
        userChoiceArticles.forEach { articlesToReturn.append($0) }
        return articlesToReturn
    }
    
    func deleteArticleFromUserChoice(articleToDelete: UserChoiceArticle) {
        do {
            try storedInformation.write {
                storedInformation.delete(articleToDelete)
            }
        }
        catch {}
    }
    
    func setLatestArticles(latestArticles: [Article]) {
        deleteLatestArticles()
        latestArticles.forEach {
            let latestArticle = LatestArticle($0)
            do {
                try storedInformation.write({
                    storedInformation.add(latestArticle)
                })
            }
            catch  {}
        }
    }
    
    func getLatestArticles() -> [Article] {
        let articles = storedInformation.objects(LatestArticle.self)
        var articlesToReturn: [Article] = []
        articles.forEach {
            let nextArticle = Article(newArticle: $0)
            articlesToReturn.append(nextArticle)
        }
        return articlesToReturn
    }
    
    func deleteLatestArticles() {
        do {
            try storedInformation.write({
                let latestArticles = storedInformation.objects(LatestArticle.self)
                storedInformation.delete(latestArticles)
            })
        }
        catch {}
    }
    
    func setLastLocation(newLocation: CLLocation) {
        guard !storedInformation.objects(UserLocation.self).isEmpty else { return }
        do {
            try storedInformation.write {
                let location = storedInformation.objects(UserLocation.self).first
                location?.setLocation(newLocation: newLocation)
            }
        }
        catch {}
    }
    
    func setFirstLocation(_ firstLocation: CLLocation) {
        guard storedInformation.objects(UserLocation.self).isEmpty else { return }
        let location = UserLocation(location: CLLocation.init(latitude: firstLocation.coordinate.latitude, longitude: firstLocation.coordinate.longitude))
        
        do {
            try storedInformation.write {
                storedInformation.add(location)
            }
        }
        catch  {}
    }
    
    func getLastLocationLatitude() -> String {
        return storedInformation.objects(UserLocation.self).first?.getLatitude() ?? ""
    }
    
    func getLastLocationLongitude() -> String {
        return storedInformation.objects(UserLocation.self).first?.getLongitude() ?? ""
    }
}
