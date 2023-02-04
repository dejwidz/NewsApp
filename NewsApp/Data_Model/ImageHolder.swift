//
//  ImageHolder.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/11/2022.
//

import Foundation
import RealmSwift
import UIKit

class ImageHolder: Object {
    @Persisted var urlToImage: String?
    @Persisted var ImageData: Data?
    
    override init() {}
    
    init(urlToImage: String?) {
        self.urlToImage = urlToImage
    }
    
    func setImage(ImageData: Data) {
        self.ImageData = ImageData
    }
    
}


