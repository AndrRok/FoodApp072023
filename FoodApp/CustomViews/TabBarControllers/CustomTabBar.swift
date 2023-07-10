//
//  CustomTabBar.swift
//  FoodApp
//
//  Created by ARMBP on 7/1/23.
//

import UIKit

final class CustomTabBar: UIViewController {
    
    private lazy var tabBar                 = UIStackView()
    private lazy var mainVCButton           = UIButton()
    private lazy var searchVCButton         = UIButton()
    private lazy var cartVCButton           = UIButton()
    private lazy var profileVCButton        = UIButton()
    private  var mainVC = MainVC()
    private  var categoryVC = CategoryVC()
    private  var cartVC = CartVC()
    private  var serarchVC = SearchVC()
    private  var profileVC = ProfileVC()
    private var isCategoryPresented: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setVC(vc: mainVC)
        configureButtons()
        redrawButtons()
        mainVCButton.configuration?.baseForegroundColor = Colors.originalBlue
        NotificationCenter.default.addObserver(self, selector: #selector(goCategoryVC(notification:)), name: Notification.Name("changeIndexToCategoryVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goMainVC(notification:)), name: Notification.Name("changeIndexToMain"), object: nil)
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
            lineView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        let arrayVC      = [mainVC, categoryVC, cartVC, profileVC, serarchVC]
        for vc in arrayVC {
            addChild(vc)
            vc.view.frame = view.bounds
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    private func configureButtons(){
        var mainButtonConfiguration = UIButton.Configuration.filled()
        mainButtonConfiguration.image = UIImage(named: "mainIcon")
        mainVCButton.configuration = mainButtonConfiguration
        setFontAndTextForButtons(mainVCButton, buttonText: "Главная")
        mainVCButton.configuration?.imagePlacement = .top
        mainVCButton.addAction(UIAction{ [self]_ in
            redrawButtons()
            mainVCButton.configuration?.baseForegroundColor = Colors.originalBlue
            switch isCategoryPresented {
            case true:
                self.setVC(vc: categoryVC)
            default:
                self.setVC(vc: mainVC)
            }
        }, for: .touchUpInside)
        
        var searchButtonConfiguration = UIButton.Configuration.filled()
        searchButtonConfiguration.image = UIImage(named: "searchIcon")
        searchVCButton.configuration = searchButtonConfiguration
        setFontAndTextForButtons(searchVCButton, buttonText: "Поиск")
        searchVCButton.configuration?.imagePlacement = .top
        searchVCButton.addAction(UIAction{ [self] _ in
            self.setVC(vc: serarchVC)
            redrawButtons()
            searchVCButton.configuration?.baseForegroundColor = Colors.originalBlue
        }, for: .touchUpInside)
        
        var cartButtonConfiguration = UIButton.Configuration.filled()
        cartButtonConfiguration.image = UIImage(named: "cartIcon")
        cartVCButton.configuration = cartButtonConfiguration
        setFontAndTextForButtons(cartVCButton, buttonText: "Корзина")
        cartVCButton.configuration?.imagePlacement = .top
        cartVCButton.addAction(UIAction{ [self]_ in
            self.setVC(vc: cartVC)
            redrawButtons()
            cartVCButton.configuration?.baseForegroundColor = Colors.originalBlue
            NotificationCenter.default.post(name: Notification.Name("reloadCart"), object: nil)
        }, for: .touchUpInside)
        
        var profileButtonConfiguration = UIButton.Configuration.filled()
        profileButtonConfiguration.image = UIImage(named: "profileIcon")
        profileVCButton.configuration = profileButtonConfiguration
        setFontAndTextForButtons(profileVCButton, buttonText: "Аккаунт")
        profileVCButton.configuration?.imagePlacement = .top
        profileVCButton.addAction(UIAction{ [self]_ in
            self.setVC(vc: profileVC)
            redrawButtons()
            profileVCButton.configuration?.baseForegroundColor = Colors.originalBlue
        }, for: .touchUpInside)
    }
    
    private func setVC(vc: UIViewController){
        DispatchQueue.main.async { [self] in
            let arrayVC      = [mainVC, categoryVC, cartVC, profileVC, serarchVC]
            for vc in arrayVC { vc.view.isHidden = true}
            vc.view.isHidden = false
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
    
    private func setFontAndTextForButtons(_ button: UIButton, buttonText: String){
        var container = AttributeContainer()
        container.font = UIFont(name: "SFProDisplay-Medium", size: 10)
        button.configuration?.attributedTitle = AttributedString(buttonText, attributes: container)
    }
    
    @objc private func goMainVC(notification: NSNotification){
        isCategoryPresented = false
        setVC(vc: mainVC)
    }
    
    @objc private func goCategoryVC(notification: NSNotification){
        setVC(vc: categoryVC)
        isCategoryPresented = true
    }
    
    @objc private func goCartVC(notification: NSNotification){
        setVC(vc: cartVC)
    }
}
