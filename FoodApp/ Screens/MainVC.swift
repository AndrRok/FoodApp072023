//
//  MainVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class MainVC: ParentVC {
    
    private lazy var navBar = UINavigationBar(frame: .zero)
    private lazy var leftView = LocationDateView()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createMainLayout(in: view))
    private lazy var profileButton = UIButton()
    private lazy var foodItems:    [FoodItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getLatestFromAPI()
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
        configureCollectionView()
    }
    
    
    //MARK: - Network calls
    private func getLatestFromAPI(){
        NetworkManager.shared.getMainRequest() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let latestsResult):
                self.foodItems = latestsResult.сategories
                DispatchQueue.main.async {
                    self.configure()}
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    //MARK: - Configure UI
    private func configureNB(){
        view.addSubview(navBar)
        navBar.backgroundColor = .systemBackground
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
    
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.reuseID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        collectionView.contentInset = insets
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    
}


//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.reuseID, for: indexPath) as! MainCell
        let foodItem = foodItems[indexPath.row]
        cell.setFromAPI(foodItem: foodItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("changeIndexToCategoryVC"), object: nil)
    }
}


