//
//  ProfileVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class ProfileVC: ParentVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: false, completion: nil)
    }
}
