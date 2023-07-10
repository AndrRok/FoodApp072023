//
//  CartVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

final class CartVC: ParentVC {
    
    private let tableView = UITableView()
    private lazy var navBar = UIView()
    private lazy var leftView = LocationDateView()
    private lazy var profileButton = UIButton()
    private let payButton = UIButton()
    public let payButtonPriceLabel  = NameLabel(textAlignment: .left, fontSize: 16, type: "medium")
    private let payButtonTitleLabel = NameLabel(textAlignment: .right, fontSize: 16, type: "medium")
    private let buttonContainer = UIView()
    private var cartArray = PersistenceManager.sharedRealm.inCartItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalPrice(notification:)), name: Notification.Name("StepperValueChanged"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [self] in
            profileButton.clipsToBounds = true
            profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width}
    }
    
    private func configure(){
        configureProfileButton()
        configureNB()
        configureTableView()
        configurePayButton()
        configurePayButtonLabels()
    }
    
    //MARK: - Configure UI
    private func configureNB(){
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubviews(leftView, profileButton)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            navBar.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 57),
            
            leftView.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            leftView.heightAnchor.constraint(equalToConstant: 42),
            leftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            profileButton.heightAnchor.constraint(equalToConstant: 44),
            profileButton.widthAnchor.constraint(equalToConstant: 44),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    
    private func configureProfileButton(){
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async { [self] in
            profileButton.setImage(resizeImage(image: UIImage(named: "face")!, targetSize: CGSize(width: 45, height: 45)), for: .normal)
        }
        profileButton.layer.borderColor = UIColor.systemBackground.cgColor
        profileButton.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            profileButton.heightAnchor.constraint(equalToConstant: 45),
            profileButton.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.rowHeight = 65
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        tableView.separatorStyle = .none
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        tableView.contentInset = insets
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func configurePayButton(){
        view.addSubview(payButton)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.backgroundColor = Colors.originalBlue
        payButton.layer.borderWidth = 0
        payButton.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -106),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configurePayButtonLabels(){
        payButton.addSubviews(buttonContainer)
        buttonContainer.addSubviews(payButtonPriceLabel, payButtonTitleLabel)
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        payButtonTitleLabel.textColor = .white
        payButtonPriceLabel.textColor = .white
        payButtonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        payButtonPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        payButtonTitleLabel.text = "Оплатить"
        payButtonPriceLabel.text = "\(calcTotalPrice()) ₽"
    
        NSLayoutConstraint.activate([
            buttonContainer.centerYAnchor.constraint(equalTo: payButton.centerYAnchor),
            buttonContainer.centerXAnchor.constraint(equalTo: payButton.centerXAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 20),
          
            payButtonTitleLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            payButtonTitleLabel.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
            
            payButtonPriceLabel.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            payButtonPriceLabel.leadingAnchor.constraint(equalTo: payButtonTitleLabel.trailingAnchor, constant: 5),
            payButtonPriceLabel.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor)
        ])
    }
    
    
    private func reloadTableView(){
        cartArray = PersistenceManager.sharedRealm.inCartItem
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.payButton)
        }
    }
    
    private func calcTotalPrice() -> String{
        var totalPrice = Int()
        for item in cartArray{
            totalPrice += Int(item.price)*Int(item.amountInCart)
        }
        return String(totalPrice)
    }
    
    @objc private func updateTotalPrice(notification: NSNotification){
        cartArray = PersistenceManager.sharedRealm.inCartItem
        payButtonPriceLabel.text = "\(calcTotalPrice()) ₽"
        reloadTableView()
    }
}



extension CartVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseID) as! CartCell
        
        let realmItem = cartArray[indexPath.row]
        let item   = Dishes(id: Int(realmItem.idOfItem)!, name: realmItem.nameOfItem, price: realmItem.price, weight: realmItem.weight, description: realmItem.description, imageUrl: realmItem.imageUrl, tegs: [])
        cell.cellId = indexPath.row
        cell.set(foodItem: item, amount: realmItem.amountInCart)
        cell.reloadCartDelegate = self
        return cell
    }
}

extension CartVC: ReloadCartProtocol{
    func reloadCart() {
        reloadTableView()
        
    }
}


