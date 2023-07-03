//
//  NameLabel.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class NameLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font          = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure(){
        textColor                                   = .label
        adjustsFontSizeToFitWidth                   = true
        lineBreakMode                               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints   = false
        numberOfLines                               = 0
        adjustsFontSizeToFitWidth                   = false
    }
}
