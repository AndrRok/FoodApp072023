//
//  CategoriesHeaderView.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

protocol FilterFoodProtocol {
    func sortFood(keyWord: String)
}

class CategoriesHeaderView: UIView {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCategoriesLayout(in: self))
    private let categoryArray = ["Все меню", "Салаты", "С рисом", "С рыбой"]
    public var delegateSortFood: FilterFoodProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        addSubview(collectionView)
        collectionView.backgroundColor                              = .systemBackground
        collectionView.clipsToBounds                                = true
        collectionView.delegate                                     = self
        collectionView.dataSource                                   = self
        collectionView.showsHorizontalScrollIndicator               = false
        collectionView.translatesAutoresizingMaskIntoConstraints    = false
        collectionView.isUserInteractionEnabled                     = true
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.contentInset = insets
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}




//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoriesHeaderView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
        let number = categoryArray[indexPath.row]
        cell.set(text: number)
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        delegateSortFood?.sortFood(keyWord: categoryArray[indexPath.row])
    }
}

