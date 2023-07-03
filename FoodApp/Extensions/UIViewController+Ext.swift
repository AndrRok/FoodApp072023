//
//  UIViewController+Ext.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

extension UIViewController {
    
    func presentCustomAllertOnMainThred(allertTitle: String, message: String, butonTitle: String){
        DispatchQueue.main.async {
            let allertVC = AlertVC(allertTitle: allertTitle, message: message, buttonTitle: butonTitle)
            allertVC.modalPresentationStyle = .overFullScreen
            allertVC.modalTransitionStyle = .crossDissolve
            self.present(allertVC, animated: true)
        }
    }
    
    func presentCustomDetailsVCOnMainThred(foodItem: Dishes){
        DispatchQueue.main.async {
            let productDetailsVC = ProductDetailsVC(foodItem: foodItem)
            productDetailsVC.modalPresentationStyle = .overFullScreen
            productDetailsVC.modalTransitionStyle = .crossDissolve
            self.present(productDetailsVC, animated: true)
        }
    }
}

