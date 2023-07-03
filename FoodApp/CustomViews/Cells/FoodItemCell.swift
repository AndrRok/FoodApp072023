//
//  FoodItemCell.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//

import UIKit


class FoodItemCell: UICollectionViewCell {
    
    public static let reuseID = "foodItemCell"
    private let nameLabel       = NameLabel(textAlignment: .left, fontSize: 12)
    private lazy var container = UIView()
    private let foodImageView                = ItemImage(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        foodImageView.setDefaultmage()
    }
    
    public func setFromAPI(dish: Dishes){
        nameLabel.text = dish.name
        foodImageView.downloadImage(fromURL: dish.imageUrl)
    }
    
    private func configure(){
        addSubview(container)
        container.addSubviews(foodImageView, nameLabel)
        container.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints        = false
        foodImageView.translatesAutoresizingMaskIntoConstraints        = false
        foodImageView.contentMode = .scaleToFill
        container.backgroundColor = Colors.lightBrown
        container.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 110),
            
            foodImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            foodImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: 90),
            foodImageView.widthAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5)
        ])
    }
    
}

