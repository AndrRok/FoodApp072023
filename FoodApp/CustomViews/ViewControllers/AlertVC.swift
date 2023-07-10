//
//  AllertVC.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit


final class AlertVC: UIViewController {
    
    private lazy var containerView = AlertContainerView()
    private let titleLabel   = NameLabel(textAlignment: .left, fontSize: 20, type: "medium")
    private let messageLabel = NameLabel(textAlignment: .left, fontSize: 20, type: "medium")
    private let actionButton = UIButton()
    private var alertTitle:  String?
    private var message:     String?
    private var buttonTitle: String?
    private let padding: CGFloat = 20
    
    init(allertTitle: String, message: String, buttonTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle  = allertTitle
        self.message     = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    private func configureContainerView(){
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func configureTitleLabel(){
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font =  UIFont(name: "SFProDisplay-Medium", size: 14)
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureActionButton(){
        containerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitleColor(.label, for: .normal)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 12)
        actionButton.backgroundColor = .systemCyan
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureMessageLabel(){
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        messageLabel.font =  UIFont(name: "SFProDisplay-Medium", size: 12)
        messageLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
}

