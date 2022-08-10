//
//  UserChoiceTableViewCell.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 20/07/2022.
//

import UIKit

class UserChoiceTableViewCell: UITableViewCell {

    weak var delegate: UserChoiceTableViewCellDelegate?

    
    var identifier = "userChoiceCell"
    var article: UserChoiceArticle?
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor.lightGray
        image.isHidden = false
        return image
    }()
    
    let readButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.black
        button.setTitle("Read now", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(readButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
//    let saveButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 10
//        button.backgroundColor = UIColor.black
//        button.setTitle("Read later", for: .normal)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
//        button.isHidden = true
//        return button
//    }()
    
//    @objc func saveButtonTapped(_ sender: UIButton){
//        print("SAVE")
//        delegate?.saveButtonHasBeenTapped(self, link: article?.url)
//    }
    
    @objc func readButtonTapped(_ sender: UIButton){
        print("READ USER CHOICE")
            delegate?.readButtonHasBeenTapped(self, link: article?.url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(image)
        contentView.addSubview(readButton)
//        contentView.addSubview(saveButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = contentView.frame.size.width
        let h = contentView.frame.size.height
        
        titleLabel.frame = CGRect(x: w * 0.02, y: h * 0.05, width: w * 0.5, height: h * 0.4)
        descriptionLabel.frame = CGRect(x: w * 0.02, y: h * 0.45, width: w * 0.5, height: h * 0.55)
        image.frame = CGRect(x: w * 0.52, y: h * 0.05, width: w * 0.45, height: h * 0.95)
        readButton.frame = CGRect(x: w * 0.6, y: h * 0.2, width: w * 0.3, height: h * 0.3)
//        saveButton.frame = CGRect(x: w * 0.6, y: h * 0.6, width: w * 0.3, height: h * 0.3)
    }
    
    func loadImage() {
        guard let url = URL(string: article?.urlToImage ?? "") else {return}
        
        let session = URLSession.shared.dataTask(with: url) { [weak self] data,_ , error in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                self?.image.image = UIImage(data: data)
            }
        }
        session.resume()
    }
    
    func loadImageWithNetworkingServices() {
//        NetworkingServices.networkSingleton.getImage(link: article?.urlToImage, completion: { result in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//                break
//            case .success(let data):
//                let image = UIImage(data: data)
//                DispatchQueue.main.async {
//                    self.image.image = image
//                }
//            }
//
//        })
        
        NetworkingServices.networkSingleton.getImageWithAlamo(link: article?.urlToImage, completion: { result in
            switch result {
            case .success(let data):
                self.image.image = UIImage(data: data)
            case .failure(let error):
                self.image.image = UIImage(systemName: "moon.stars")
                print(error.localizedDescription)
            }
            
            
        })
        
    }
    
}

protocol UserChoiceTableViewCellDelegate: AnyObject {
    func readButtonHasBeenTapped(_ userChoiceTableViewCell: UserChoiceTableViewCell, link: String?)
}