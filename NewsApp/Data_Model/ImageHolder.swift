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

    init(imageURL: String) {
        self.imageURL = imageURL
    }

    func downloadImage() {
        guard !isAlreadyDownloading else {return}
        
        isAlreadyDownloading = true

        NetworkingServices.shared.getImageWithAlamo(link: imageURL, completion: {result in
            switch result {

            case .success(let data):
                self.cachedImage = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })

    }


}
