//
//  NEWSTableViewCell.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 16/07/2022.
//

import UIKit

protocol newsTableViewCellDelegate: AnyObject {
    func readButtonHasBeenTapped(_ newsTableViewCell: NewsTableViewCell, link: String?)
    func saveButtonHasBeenTapped(_ newsTableViewCell: NewsTableViewCell, article: Article?)
}

class NewsTableViewCell: UITableViewCell {

    weak var delegate: newsTableViewCellDelegate?
    
    var identifier = "newsCell"
    var article: Article?
    var imageHolder: ImageHolder?
    
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.isHidden = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor.white
        image.tintColor = UIColor.black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let readButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.black
        button.setTitle("Read now", for: .normal)
        button.setTitleColor(CustomColors.fontColor, for: .normal)
        button.addTarget(self, action: #selector(readButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.black
        button.setTitle("Read later", for: .normal)
        button.setTitleColor(CustomColors.fontColor, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func saveButtonTapped(_ sender: UIButton){
        delegate?.saveButtonHasBeenTapped(self, article: article)
    }
    
    @objc func readButtonTapped(_ sender: UIButton){
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
        contentView.addSubview(saveButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = CustomColors.backColor
        
        let w = contentView.frame.size.width
        let h = contentView.frame.size.height
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: h * 0.05),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: w * 0.02),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            titleLabel.heightAnchor.constraint(equalToConstant: h * 0.4),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: h * 0.5),
            
            image.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            image.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(w * 0.015)),
            
            readButton.topAnchor.constraint(equalTo: image.topAnchor, constant: h * 0.15),
            readButton.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            readButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            readButton.heightAnchor.constraint(equalToConstant: h * 0.3),
            
            saveButton.topAnchor.constraint(equalTo: readButton.bottomAnchor, constant: h * 0.1),
            saveButton.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: readButton.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: readButton.heightAnchor)
        ])
    }
    
    func loadImageWithNetworkingServices() {
        NetworkingServices.shared.getImageWithAlamo(link: article?.urlToImage, completion: { result in
            switch result {
            case .success(let data):
                self.image.image = UIImage(data: data)
            case .failure(let error):
                self.image.image = UIImage(named: "newsAppIcon")
                print(error.localizedDescription)
            }
        })
    }
    
    func setImageHolder(imageHolder: ImageHolder) {
        self.imageHolder = imageHolder
//        imageHolder.imageIsReady = setupImage(image:)
        self.image.image = imageHolder.cachedImage
    }
    
    func setupImage(image: UIImage) {
        self.image.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        self.image.alpha = 1
        self.readButton.isHidden = true
        self.saveButton.isHidden = true
        self.contentView.backgroundColor = CustomColors.backColor
        self.image.image = UIImage(named: "newsAppIcon")
    }
}



