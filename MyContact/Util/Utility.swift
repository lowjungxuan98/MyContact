//
//  Utility.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation
import UIKit

class Utility {
    static let shared = Utility()
    
    func checkCredential() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let vc: UIViewController = {
                let entities = LocalStorage.shared.fetchEntities()
                if entities.isEmpty {
                    return LoginViewController(viewModel: LoginViewModel())
                } else {
                    return MainTabBarController()
                }
            }()
            sceneDelegate.changeRootViewController(to: UINavigationController(rootViewController: vc))
        }
    }
}
