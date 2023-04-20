//
//  UserChoiceTableViewCell.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 20/07/2022.
//

import UIKit

final class UserChoiceTableViewCell: UITableViewCell {
    
    weak var delegate: UserChoiceTableViewCellDelegate?
    var identifier = "userChoiceCell"
    var article: UserChoiceArticle?
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        return label
    }()
    
    let descriptionLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.white
        image.tintColor = UIColor.black
        image.isHidden = false
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let readButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.black
        button.setTitle("Read now", for: .normal)
        button.setTitleColor(CustomColors.fontColorLight, for: .normal)
        button.addTarget(self, action: #selector(readButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private  func readButtonTapped(_ sender: UIButton){
        delegate?.readButtonHasBeenTapped(self, link: article?.url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupInterface() {
        self.contentView.backgroundColor = CustomColors.backColor
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(image)
        contentView.addSubview(readButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            image.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            image.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            readButton.topAnchor.constraint(equalTo: image.topAnchor, constant: 30),
            readButton.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            readButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            readButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
            ])
    }
    
    func loadImageWithNetworkingServices() {
        NetworkingServices.shared.getImage(link: article?.urlToImage, completion: { result in
            switch result {
            case .success(let data):
                self.image.image = UIImage(data: data)
            case .failure(let error):
                self.image.image = UIImage(named: "newsAppIcon")
                print(error.localizedDescription)
            }
        })
    }
}

protocol UserChoiceTableViewCellDelegate: AnyObject {
    func readButtonHasBeenTapped(_ userChoiceTableViewCell: UserChoiceTableViewCell, link: String?)
}
