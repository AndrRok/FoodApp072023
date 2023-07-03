//
//  MainCell.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    public static let reuseID = "mainCell"
    private let nameLabel       = NameLabel(textAlignment: .left, fontSize: 20)
    private let foodImageView                = ItemImage(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
            foodImageView.setDefaultmage()
    }
    
    public func setFromAPI(foodItem: FoodItems){
        nameLabel.text = foodItem.name
        foodImageView.downloadImage(fromURL: foodItem.imageUrl)
    }
    
    private func configure(){
        addSubviews(foodImageView, nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints        = false
        foodImageView.translatesAutoresizingMaskIntoConstraints        = false
        foodImageView.setDefaultmage()
        foodImageView.layer.cornerRadius = 10
        nameLabel.textColor = .black
        
        NSLayoutConstraint.activate([
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            foodImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            foodImageView.topAnchor.constraint(equalTo: topAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: Values.padding),
            nameLabel.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: 0.25*Values.padding),
        ])
    }
}
