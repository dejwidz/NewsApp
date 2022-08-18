//
//  DataStorage.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 24/07/2022.
//

import Foundation
import RealmSwift
import CoreLocation

class DataStorage {
    
    static var shared = DataStorage()
    private var storedInformation = try! Realm()
    
    private init() {}
    
    func addUserChoiceArticle(newArticle: Article) {
        let newUserChoiceArticle = UserChoiceArticle(newArticle: newArticle)
        try! storedInformation.write {
            storedInformation.add(newUserChoiceArticle)
        }
    }
    
    func getUserChoiceArticles() -> [UserChoiceArticle] {
        let userChoiceArticles = storedInformation.objects(UserChoiceArticle.self)
        var articlesToReturn: [UserChoiceArticle] = []
        for i in userChoiceArticles {
            articlesToReturn.append(i)
        }
        return articlesToReturn
    }
    
    func deleteArticleFromUserChoice(articleToDelete: UserChoiceArticle) {
        try! storedInformation.write {
            storedInformation.delete(articleToDelete)
        }
    }
    
    func setLatestArticles(latestArticles: [Article]) {
        deleteLatestArticles()
        for i in latestArticles {
            let latestArticle = LatestArticle(newArticle: i)
            try! storedInformation.write({
                storedInformation.add(latestArticle)
            })
        }
    }
    
    func getLatestArticles() -> [Article] {
        let articles = storedInformation.objects(LatestArticle.self)
        var articlesToReturn: [Article] = []
        for i in articles {
            let nextArticle = Article(newArticle: i)
            articlesToReturn.append(nextArticle)
        }
        return articlesToReturn
    }
    
    func deleteLatestArticles() {
        try! storedInformation.write({
            let latestArticles = storedInformation.objects(LatestArticle.self)
            storedInformation.delete(latestArticles)
        })
    }
    
    func setLastLocation(newLocation: CLLocation) {
        guard !storedInformation.objects(UserLocation.self).isEmpty else {
            setFirstLocation()
            return
        }
        try! storedInformation.write {
            let location = storedInformation.objects(UserLocation.self).first
            location?.setLocation(newLocation: newLocation)
        }
    }
    
    func setFirstLocation() {
        guard storedInformation.objects(UserLocation.self).isEmpty else {
            return
        }
        let location = UserLocation(location: CLLocation.init(latitude: +37.78583400, longitude: -122.40641700))
        
        try! storedInformation.write {
            storedInformation.add(location)
        }
    }
    
    func getLastLocationLatitude() -> String {
        let location = storedInformation.objects(UserLocation.self).first
        return (location?.getLatitude())!
    }
    
    func getLastLocationLongitude() -> String {
        let location = storedInformation.objects(UserLocation.self).first
        return (location?.getLongitude())!
    }
    
    
    
    
}

