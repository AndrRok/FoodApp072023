//
//  UIHelper.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit


enum UIHelper{
    
    //MARK: - Compositional layout for categories
    
    static func createCategoriesLayout(in view: UIView) -> UICollectionViewCompositionalLayout{
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 2, bottom: 10, trailing: 2)
        // Group
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)), repeatingSubitem: item, count: 1)
        
        // Sections
        
        let section = NSCollectionLayoutSection(group: group)
    
        // Return
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        return layout

    }
    
    //MARK: - Compositional layout for main VC
    static func createMainLayout(in view: UIView) -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            // Item
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 10, trailing: 2)
            // Group
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240)), repeatingSubitem: item, count: 1)
            
            // Sections
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    //MARK: - Compositional layout for details VC
    static func createSecondVCLayout(in view: UIView) -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            // Item
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
            // Group
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1/4)), repeatingSubitem: item, count: 3)
            
            // Sections
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
}

