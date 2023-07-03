//
//  CategoryVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class CategoryVC: ParentVC {
    
    private lazy var navBar = UINavigationBar(frame: .zero)
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
        configureProfileButton()
        configureNB()
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
        navBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navBar.shadowImage = UIImage()
        let goBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        goBackButton.setImage(image, for: .normal)
        goBackButton.tintColor = .label
        goBackButton.layer.cornerRadius = 10
        goBackButton.layer.masksToBounds = true
        goBackButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let navItem = UINavigationItem()
        let backButton          = UIBarButtonItem(customView: goBackButton)
        let profileButton          = UIBarButtonItem(customView: profileButton)
        navItem.rightBarButtonItem = profileButton
        navItem.leftBarButtonItem = backButton
        navBar.setItems([navItem], animated: false)
        navItem.title = "Азиатская кухня"
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 40)
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func dismissVC(){
        NotificationCenter.default.post(name: Notification.Name("changeIndexToMain"), object: nil)
        self.dismiss(animated: true, completion: nil)
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
