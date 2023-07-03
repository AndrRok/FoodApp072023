//
//  CustomTabBar.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

class CustomTabBar: UIViewController {
    
    private lazy var tabBar                 = UIStackView()
    private lazy var mainVCButton           = UIButton()
    private lazy var searchVCButton         = UIButton()
    private lazy var cartVCButton           = UIButton()
    private lazy var profileVCButton        = UIButton()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setVC(vc: MainVC())
        configureButtons()
        let buttonsArray = [mainVCButton, cartVCButton, searchVCButton, profileVCButton]
        for button in buttonsArray {
            button.configuration?.baseForegroundColor = .secondaryLabel
            button.configuration?.baseBackgroundColor = .systemBackground
        }
        mainVCButton.configuration?.baseForegroundColor = .systemCyan
        NotificationCenter.default.addObserver(self, selector: #selector(goCategoryVC(notification:)), name: Notification.Name("changeIndexToCategoryVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goMainVC(notification:)), name: Notification.Name("changeIndexToMain"), object: nil)
    }

    
    override func viewDidLayoutSubviews() {
        makeButtonCircle(buttons: [mainVCButton, cartVCButton, searchVCButton, profileVCButton])
    }
    
    
    private func configure(){
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.masksToBounds = true
        tabBar.addArrangedSubview(mainVCButton)
        tabBar.addArrangedSubview(searchVCButton)
        tabBar.addArrangedSubview(cartVCButton)
        tabBar.addArrangedSubview(profileVCButton)
        tabBar.axis = .horizontal
        tabBar.alignment = .center
        tabBar.distribution = .equalCentering
        tabBar.spacing = 5
        tabBar.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        tabBar.isLayoutMarginsRelativeArrangement = true
        let lineView = UIView()
        tabBar.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .systemGray4
        
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 88),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            lineView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
    
    private func configureButtons(){
        var mainButtonConfiguration = UIButton.Configuration.filled()
        mainButtonConfiguration.image = UIImage(named: "mainIcon")
        mainVCButton.configuration = mainButtonConfiguration
        mainVCButton.addAction(UIAction{ [self]_ in
            self.setVC(vc: MainVC())
            redrawButtons()
            mainVCButton.configuration?.baseForegroundColor = .systemCyan
        }, for: .touchUpInside)
        
        var cartButtonConfiguration = UIButton.Configuration.filled()
        cartButtonConfiguration.image = UIImage(named: "cartIcon")
        cartVCButton.configuration = cartButtonConfiguration
        cartVCButton.addAction(UIAction{ [self]_ in
            self.setVC(vc: CartVC())
            redrawButtons()
            cartVCButton.configuration?.baseForegroundColor = .systemCyan
        }, for: .touchUpInside)
        
        var searchButtonConfiguration = UIButton.Configuration.filled()
        searchButtonConfiguration.image = UIImage(named: "searchIcon")
        searchVCButton.configuration = searchButtonConfiguration
        searchVCButton.addAction(UIAction{ [self] _ in
            self.setVC(vc: SearchVC())
            redrawButtons()
            searchVCButton.configuration?.baseForegroundColor = .systemCyan
        }, for: .touchUpInside)
        
        var profileButtonConfiguration = UIButton.Configuration.filled()
        profileButtonConfiguration.image = UIImage(named: "profileIcon")
        profileVCButton.configuration = profileButtonConfiguration
        profileVCButton.addAction(UIAction{ [self]_ in
            self.setVC(vc: ProfileVC())
            redrawButtons()
            profileVCButton.configuration?.baseForegroundColor = .systemCyan
        }, for: .touchUpInside)
    }
    
    private func setVC(vc: UIViewController){
        DispatchQueue.main.async { [self] in
            view.subviews.forEach({ $0.removeFromSuperview() })
            configure()
            addChild(vc)
            vc.view.frame = view.bounds
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
            view.bringSubviewToFront(tabBar)
        }
    }
    
    private func makeButtonCircle(buttons: [UIButton]){
        for i  in buttons{
            i.widthAnchor.constraint(equalToConstant: 50).isActive = true
            i.heightAnchor.constraint(equalToConstant: 50).isActive = true
            i.clipsToBounds = true
            i.layer.cornerRadius = 0.5 * i.bounds.size.width
        }
    }
    
    private func redrawButtons(){
        let buttonsArray = [mainVCButton, cartVCButton, searchVCButton, profileVCButton]
        for button in buttonsArray {
            button.configuration?.baseForegroundColor = .secondaryLabel
            button.configuration?.baseBackgroundColor = .systemBackground
        }
    }
    
    @objc private func goMainVC(notification: NSNotification){
        setVC(vc: MainVC())
    }
    
    @objc private func goCategoryVC(notification: NSNotification){
        setVC(vc: CategoryVC())
    }
    
    @objc private func goCartVC(notification: NSNotification){
        setVC(vc: MainVC())
    }
}
