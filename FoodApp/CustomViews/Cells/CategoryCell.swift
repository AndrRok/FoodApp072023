//
//  CategoryCell.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    private var cateogoryLabel = NameLabel(textAlignment: .center, fontSize: 12)
    public static let reuseID = "categoryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor =  .quaternaryLabel
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(text: String){
        cateogoryLabel.text = text
    }
    
    override var isSelected: Bool {
        didSet {
            DispatchQueue.main.async {
                self.contentView.backgroundColor  = self.isSelected ? Colors.originalBlue   : .quaternaryLabel
                self.cateogoryLabel.textColor     = self.isSelected ? .white     : .black
            }
        }
    }
    
    
    //MARK: - Configure
    private func configure(){
        contentView.addSubview(cateogoryLabel)
        contentView.layer.cornerRadius = 10
        layer.cornerRadius = 10
        backgroundColor = .white
        cateogoryLabel.textColor = .black
        
        NSLayoutConstraint.activate([
            cateogoryLabel.topAnchor.constraint(equalTo: topAnchor),
            cateogoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cateogoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            cateogoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
