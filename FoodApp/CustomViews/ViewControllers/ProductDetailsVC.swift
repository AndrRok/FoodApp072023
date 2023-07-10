//
//  ProductDetailsVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//


import UIKit


final class ProductDetailsVC: UIViewController {
    
    private let containerView = AlertContainerView()
    private let foodImageView = ItemImage(frame: .zero)
    private let nameLabel = NameLabel(textAlignment: .left, fontSize: 16, type: "medium")
    private let priceLabel = NameLabel(textAlignment: .left, fontSize: 14, type: "regular")
    private let weightLabel = NameLabel(textAlignment: .left, fontSize: 14, type: "regular")
    private let descriptionLabel = NameLabel(textAlignment: .left, fontSize: 14, type: "regular")
    private let actionButton = UIButton()
    private let addToFavoritesButton  = UIButton()
    private let  closeButton   = UIButton()
    private let imageContainer = UIView()
    private let padding: CGFloat = 10
    private var item: Dishes!
    
    init(foodItem: Dishes){
        super.init(nibName: nil, bundle: nil)
        self.item = foodItem
        nameLabel.text = item.name
        priceLabel.text = "\(String(item.price)) ₽"
        weightLabel.text = "· \(String(item.weight))г"
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
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 446)
        ])
    }
    
    
    //MARK: - Configure UI
    private func configureImageView(){
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.backgroundColor = Colors.lightBrown
        imageContainer.layer.cornerRadius =  10
        containerView.addSubview(imageContainer)
        imageContainer.addSubview(foodImageView)
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.contentMode = .scaleAspectFit
        foodImageView.layer.cornerRadius =  10
        
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            imageContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageContainer.heightAnchor.constraint(equalToConstant: 230),
            
            foodImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            foodImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            foodImageView.widthAnchor.constraint(equalToConstant: 200),
            foodImageView.heightAnchor.constraint(equalToConstant: 200),
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
            closeButton.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -8),
            closeButton.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
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
            addToFavoritesButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            addToFavoritesButton.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 40),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureNameLabel(){
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureActionButton(){
        containerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitleColor(.label, for: .normal)
        actionButton.setTitle("Добавить в корзину", for: .normal)
        actionButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        actionButton.backgroundColor = Colors.originalBlue
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        actionButton.setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configurePriceLabel(){
        containerView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.numberOfLines = 1
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
        weightLabel.numberOfLines = 1
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
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .systemGray
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
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
