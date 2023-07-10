//
//  LocationDateView.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//

import UIKit

final class LocationDateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let monthName = DateFormatter().monthSymbols[month - 1]
        let labelOne = NameLabel(textAlignment: .left, fontSize: 18, type: "medium")
        let labelTwo = NameLabel(textAlignment: .left, fontSize: 14, type: "medium")
        let imageOne = UIImageView(image:  UIImage(named: "navigationIcon"))
        labelOne.text = "Санкт-Петербург"
        labelTwo.text = "\(day) \(monthName), \(year)"
        addSubviews(labelOne, labelTwo, imageOne)
        labelOne.translatesAutoresizingMaskIntoConstraints = false
        labelTwo.translatesAutoresizingMaskIntoConstraints = false
        imageOne.translatesAutoresizingMaskIntoConstraints = false
        imageOne.tintColor = .label
        labelTwo.textColor  = UIColor(white: 0, alpha: 0.5)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 45),
            widthAnchor.constraint(equalToConstant: 145),
            
            imageOne.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imageOne.heightAnchor.constraint(equalToConstant: 24),
            imageOne.widthAnchor.constraint(equalToConstant: 24),
            
            labelOne.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            labelOne.leadingAnchor.constraint(equalTo: imageOne.trailingAnchor, constant: 4),
            labelOne.heightAnchor.constraint(equalToConstant: 22),
            
            labelTwo.topAnchor.constraint(equalTo: labelOne.bottomAnchor, constant: 4),
            labelTwo.leadingAnchor.constraint(equalTo: imageOne.trailingAnchor, constant: 5),
            labelTwo.heightAnchor.constraint(equalToConstant: 16),
            
        ])
    }
}
