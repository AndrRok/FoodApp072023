//
//  SearchVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: false, completion: nil)
    }
}
