//
//  CustomStepper.swift
//  FoodApp
//
//  Created by ARMBP on 7/2/23.
//

import UIKit

protocol SendValueProtocol{
    func setValue(value: Int)
}

final class CustomStepper: UIView {
    
    var sendValueDelegate: SendValueProtocol?
    private let stackView    = UIStackView()
    private let minusButton  = UIButton()
    private let plusButton   = UIButton()
    private let valueLabel   = UILabel()
    private var currentValue = Int()
    private var cellId = Int()
    private var cartArray = PersistenceManager.sharedRealm.inCartItem
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = Colors.lightGrayStepper
        layer.cornerRadius = 10
        sendValueDelegate?.setValue(value: currentValue)
        configureStack()
        configureButtons()
        configureValueLabel()
    }
    
    public func setValueOfStepper(amount: Int, id: Int){
        currentValue = amount
        cellId = id
        valueLabel.text = "\(currentValue)"
    }
    
    private func configureStack(){
        addSubview(stackView)
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(plusButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureButtons(){
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        minusButton.tintColor = .black
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .black
        plusButton.addTarget(self, action: #selector(increaseValue), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(decreaseValue), for: .touchUpInside)
    }
    
    private func configureValueLabel(){
        valueLabel.text = "\(currentValue)"
        valueLabel.textAlignment = .center
        valueLabel.textColor = .black
        valueLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
    }
    
    @objc private func increaseValue(){
        switch currentValue {
        case 1...:
            currentValue += 1
            valueLabel.text = "\(currentValue)"
            let item = cartArray[cellId]
            PersistenceManager.sharedRealm.editObjectAt(idForEdit: item.idOfItem, increase: true)
            sendValueDelegate?.setValue(value: currentValue)
        default:
            break
        }
    }
    
    @objc private func decreaseValue(){
        let item = cartArray[cellId]
        switch currentValue {
        case 2...:
            currentValue -= 1
            valueLabel.text = "\(currentValue)"
            PersistenceManager.sharedRealm.editObjectAt(idForEdit: item.idOfItem, increase: false)
        case 1:
            PersistenceManager.sharedRealm.deleteDataFromCart(idForDelete: item.idOfItem)
        default:
            break
        }
        sendValueDelegate?.setValue(value: currentValue)
    }
}
