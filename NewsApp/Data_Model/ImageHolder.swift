//
//  ImageHolder.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/11/2022.
//

import Foundation
import UIKit

final class ImageHolder {
    var imageData: Data?
    var imageURL: String?
    var isAlreadyDownloading = false
    var id: Int?
    var cachedImage: UIImage?
    var netDataManager: NetDataSupplier?
    
    init(imageURL: String, netDataManager: NetDataSupplier) {
        self.imageURL = imageURL
        self.netDataManager = netDataManager
    }
    
    func downloadImage() {
        guard !isAlreadyDownloading else {return}
        
        isAlreadyDownloading = true
        
        netDataManager?.getImage(link: imageURL, completion: {result in
            switch result {
                
            case .success(let data):
                self.cachedImage = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
