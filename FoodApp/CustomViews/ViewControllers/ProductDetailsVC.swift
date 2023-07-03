//
//  ProductDetailsVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//


import UIKit


class ProductDetailsVC: UIViewController {
    
    private lazy var containerView = AlertContainerView()
    private lazy var foodImageView = ItemImage(frame: .zero)
    private let nameLabel   = UILabel()
    private let priceLabel = UILabel()
    private let weightLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actionButton = UIButton()
    private lazy var addToFavoritesButton   = UIButton()
    private lazy var closeButton   = UIButton()
    private let padding: CGFloat = 10
    private var item: Dishes!
    
    init(foodItem: Dishes){
        super.init(nibName: nil, bundle: nil)
        self.item = foodItem
        nameLabel.text = item.name
        priceLabel.text = "\(String(item.price))₽"
        weightLabel.text = "• \(String(item.weight))г"
        descriptionLabel.text = item.description
        foodImageView.downloadImage(fromURL: item.imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureImageView()
        configureCloseButton()
        configureAddToFavoritesButton()
        configureNameLabel()
        configureActionButton()
        configurePriceLabel()
        configureDescriptionLabel()
        configureWeightLabel()
    }
    
    private func configureContainerView(){
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 343),
            containerView.heightAnchor.constraint(equalToConstant: 446)
        ])
    }
    
    
    //MARK: - Configure UI
    private func configureImageView(){
        containerView.addSubview(foodImageView)
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.contentMode = .scaleAspectFit
        foodImageView.layer.cornerRadius =  10
        foodImageView.backgroundColor = Colors.lightBrown
        
        NSLayoutConstraint.activate([
            foodImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            foodImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            foodImageView.widthAnchor.constraint(equalToConstant: 300),
            foodImageView.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
    
    
    
    
    private func configureCloseButton(){
        containerView.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = .white
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.layer.cornerRadius = 8
        
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: -10),
            closeButton.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
    }
    
    
    private func configureAddToFavoritesButton(){
        containerView.addSubview(addToFavoritesButton)
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.backgroundColor = .white
        addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        addToFavoritesButton.tintColor = .black
        addToFavoritesButton.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            addToFavoritesButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            addToFavoritesButton.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: 10),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 30),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
    }
    
    
    private func configureNameLabel(){
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font =  UIFont(name: "Montserrat", size: 14)
        nameLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureActionButton(){
        containerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitleColor(.label, for: .normal)
        actionButton.setTitle("Добавить в корзину", for: .normal)
        actionButton.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
        actionButton.backgroundColor = Colors.originalBlue
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configurePriceLabel(){
        containerView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.numberOfLines      = 1
        priceLabel.font =  UIFont(name: "Montserrat", size: 12)
        priceLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: priceLabel.intrinsicContentSize.width)
        ])
    }
    
    
    private func configureWeightLabel(){
        containerView.addSubview(weightLabel)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.numberOfLines      = 1
        weightLabel.font =  UIFont(name: "Montserrat", size: 12)
        weightLabel.textAlignment = .left
        weightLabel.textColor = .systemGray2
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            weightLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 2),
        ])
    }
    
    
    private func configureDescriptionLabel(){
        containerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines      = 0
        descriptionLabel.font =  UIFont(name: "Montserrat", size: 12)
        descriptionLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -5)
        ])
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addToCart(){
        if item != nil{
            guard PersistenceManager.sharedRealm.inCartObjectExist(primaryKey: String(item.id)) else {
                PersistenceManager.sharedRealm.addToCart(item: item, amount: 1)
                dismiss(animated: true, completion: nil)
                return
            }
            PersistenceManager.sharedRealm.editObjectAt(idForEdit: String(item.id), increase: true)
            dismiss(animated: true, completion: nil)
        }
    }
}
