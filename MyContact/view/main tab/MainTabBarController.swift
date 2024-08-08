//
//  MainTabBarController.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let first = DashboardViewController(viewModel: DashboardViewModel())
        let second = ProfileViewController(viewModel: ProfileViewModel())
        
        first.tabBarItem = UITabBarItem(title: nil, image: MyImage.shared.icDashboard, tag: 0)
        second.tabBarItem = UITabBarItem(title: nil, image: MyImage.shared.icPerson, tag: 1)
        
        viewControllers = [first, second]
        
        tabBar.tintColor = ColorPalette.shared.blue_0077B6
        tabBar.unselectedItemTintColor = ColorPalette.shared.gray_CCCCCC
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5))
        separatorView.backgroundColor = ColorPalette.shared.gray_EBEBEB
        tabBar.addSubview(separatorView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
