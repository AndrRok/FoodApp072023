//
//  CartCell.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//

import UIKit


protocol ReloadCartProtocol{
    func reloadCart()
}

final class CartCell: UITableViewCell {
    
    private var cartArray = PersistenceManager.sharedRealm.inCartItem
    static let reuseID      = "cartCell"
    private let imageImageView  = ItemImage(frame: .zero)
    private let nameLabel       = NameLabel(textAlignment: .left, fontSize: 14, type: "regular")
    private let priceLabel      = NameLabel(textAlignment: .left, fontSize: 14, type: "regular")
    private let weightLabel     = NameLabel(textAlignment: .left, fontSize: 14, type: "regular")
    public  lazy var stepper    = CustomStepper()
    private var price         = Int()
    private var amountOfItems = Int()
    public var cellId         = Int()
    private lazy var container = UIView()
    var reloadCartDelegate: ReloadCartProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageImageView.setDefaultmage()
    }
    
    public func set(foodItem: Dishes, amount: Int){
        DispatchQueue.main.async{ [self] in
            amountOfItems = amount
            nameLabel.text = foodItem.name
            weightLabel.text = "· \(String(foodItem.weight))г"
            imageImageView.downloadImage(fromURL: foodItem.imageUrl)
            priceLabel.text = "\(foodItem.price*amountOfItems) ₽"
            stepper.setValueOfStepper(amount: amount, id: cellId)
        }
    }
    
    private func configure(){
        stepper.sendValueDelegate = self
        configureUI()
    }
    
    private func configureUI(){
        contentView.addSubviews(container, nameLabel, priceLabel, weightLabel, stepper)
        container.addSubviews(imageImageView)
        imageImageView.layer.masksToBounds = true
        imageImageView.layer.cornerRadius = 20
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints  = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        stepper.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .label
        priceLabel.textColor = .label
        imageImageView.contentMode = .scaleToFill
        weightLabel.textColor = .secondaryLabel
        imageImageView.backgroundColor = Colors.lightBrown
        container.backgroundColor = Colors.lightBrown
        container.layer.cornerRadius = 10
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            container.heightAnchor.constraint(equalToConstant: 65),
            container.widthAnchor.constraint(equalToConstant: 65),
            
            imageImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            imageImageView.heightAnchor.constraint(equalToConstant: 60),
            imageImageView.widthAnchor.constraint(equalToConstant: 60),
            
            stepper.centerYAnchor.constraint(equalTo: centerYAnchor),
            stepper.widthAnchor.constraint(equalToConstant: 100),
            stepper.heightAnchor.constraint(equalToConstant: 30),
            stepper.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageImageView.topAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: imageImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -padding),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        
            weightLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 3),
            weightLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -padding),
            //weightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
            
        ])
    }
}


extension CartCell: SendValueProtocol{
    func setValue(value: Int) {
        amountOfItems = value
        priceLabel.text = "\(Int(price*amountOfItems)) ₽"
        NotificationCenter.default.post(name: Notification.Name("StepperValueChanged"), object: nil)
    }
}
