//
//  NameLabel.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

final class NameLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, type: String){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        switch type {
        case "medium":
            self.font          = UIFont(name: "SFProDisplay-Medium", size: fontSize)
        case "regular":
            self.font          = UIFont(name: "SFProDisplay-Regular", size: fontSize)
        default:
            break
        }
        
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
