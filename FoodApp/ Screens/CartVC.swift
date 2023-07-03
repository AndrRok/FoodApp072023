//
//  CartVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class CartVC: ParentVC {
    
    private let tableView = UITableView()
    private lazy var navBar = UINavigationBar(frame: .zero)
    private lazy var leftView = LocationDateView()
    private lazy var profileButton = UIButton()
    private let payButton = UIButton()
    public let payButtonPriceLabel  = NameLabel(textAlignment: .left, fontSize: 20)
    private let payButtonTitleLabel = NameLabel(textAlignment: .right, fontSize: 20)
    private let weightLabel = UILabel()
    private lazy var buttonStack = UIStackView()
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
        navBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navBar.shadowImage = UIImage()
        let navItem = UINavigationItem()
        let placeItem          = UIBarButtonItem(customView: leftView)
        let profileItem = UIBarButtonItem(customView: profileButton)
        navItem.leftBarButtonItem = placeItem
        navItem.rightBarButtonItem = profileItem
        navBar.setItems([navItem], animated: false)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
    private func configureProfileButton(){
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async { [self] in
            profileButton.setImage(resizeImage(image: UIImage(named: "face")!, targetSize: CGSize(width: 45, height: 45)), for: .normal)
        }
        
        NSLayoutConstraint.activate([
            profileButton.heightAnchor.constraint(equalToConstant: 45),
            profileButton.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseID)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        tableView.contentInset = insets
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            payButton.widthAnchor.constraint(equalToConstant: 340),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configurePayButtonLabels(){
        payButton.addSubviews(buttonStack)
        payButtonTitleLabel.textColor = .white
        payButtonPriceLabel.textColor = .white
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        payButtonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        payButtonPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(payButtonTitleLabel)
        buttonStack.addArrangedSubview(payButtonPriceLabel)
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        payButtonTitleLabel.text = "Оплатить"
        payButtonPriceLabel.text = "\(calcTotalPrice())₽"
        
        NSLayoutConstraint.activate([
            buttonStack.centerYAnchor.constraint(equalTo: payButton.centerYAnchor),
            buttonStack.centerXAnchor.constraint(equalTo: payButton.centerXAnchor),
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
        payButtonPriceLabel.text = "\(calcTotalPrice())₽"
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


