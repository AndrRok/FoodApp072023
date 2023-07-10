//
//  ItemImage.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//

import UIKit

final class ItemImage: UIImageView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        clipsToBounds = true
        DispatchQueue.main.async { [self] in
            image  = Images.placeholder
        }
    }
    
    func downloadImage(fromURL url: String){
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {self.image = image}
        }
    }
    
    func setSystemImage(imageName: String){
        DispatchQueue.main.async {self.image = UIImage(systemName: "\(imageName)")}
    }
    
    func setDefaultmage(){
        DispatchQueue.main.async {self.image = UIImage(named: "placeholderimage")}
    }
    
    
}
