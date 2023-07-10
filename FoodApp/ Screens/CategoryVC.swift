//
//  CategoryVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

final class CategoryVC: ParentVC {
    
    private lazy var navBar = UIView()
    private lazy var profileButton          = UIButton()
    private lazy var headerViewCategories   = CategoriesHeaderView(frame: .zero)
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createSecondVCLayout(in: view))
    private lazy var dishesArray:    [Dishes]      = []
    private var keyWord: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getDishesFromAPI(filter: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [self] in
            profileButton.clipsToBounds = true
            profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width
        }
    }
    
    private func configure(){
        configureNB()
        configureProfileButton()
        configureStickyHeader()
        configureCollectionView()
        headerViewCategories.delegateSortFood = self
    }
    
    //MARK: - Network calls
    private func getDishesFromAPI(filter: Bool){
        NetworkManager.shared.getDishesRequest() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dishesResult):
                self.dishesArray = dishesResult.dishes
                guard filter else {
                    DispatchQueue.main.async {
                        self.configure()
                    }
                    return
                }
                dishesArray = dishesArray.filter { $0.tegs.contains(self.keyWord) }
                reloadCollectionView()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    //MARK: - Configure UI
    private func configureNB(){
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let goBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        goBackButton.setImage(image, for: .normal)
        goBackButton.tintColor = .label
        goBackButton.layer.cornerRadius = 10
        goBackButton.layer.masksToBounds = true
        goBackButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        let titleLabel = NameLabel(textAlignment: .center, fontSize: 18, type: "medium")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Азиатская кухня"
        
        navBar.addSubviews(goBackButton, titleLabel, profileButton)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            navBar.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 40),
            
            goBackButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
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
            profileButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            profileButton.heightAnchor.constraint(equalToConstant: 44),
            profileButton.widthAnchor.constraint(equalToConstant: 44),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    
    private func configureStickyHeader(){
        view.addSubview(headerViewCategories)
        headerViewCategories.translatesAutoresizingMaskIntoConstraints = false
        headerViewCategories.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            headerViewCategories.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 5),
            headerViewCategories.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerViewCategories.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewCategories.widthAnchor.constraint(equalToConstant: view.frame.width),
            headerViewCategories.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FoodItemCell.self, forCellWithReuseIdentifier: FoodItemCell.reuseID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        collectionView.contentInset = insets
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerViewCategories.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func dismissVC(){
        NotificationCenter.default.post(name: Notification.Name("changeIndexToMain"), object: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - ReloadCollectionView
    private func reloadCollectionView(){
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodItemCell.reuseID, for: indexPath) as! FoodItemCell
        let dish = dishesArray[indexPath.row]
        cell.setFromAPI(dish: dish)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dish = dishesArray[indexPath.row]
        self.presentCustomDetailsVCOnMainThred(foodItem: dish)
    }
}

extension CategoryVC: FilterFoodProtocol{
    func sortFood(keyWord: String) {
        self.keyWord = keyWord
        getDishesFromAPI(filter: true)
    }
}
