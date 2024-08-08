//
//  LoginViewModel.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel {
    let userId = BehaviorRelay<String?>(value: nil)
    
    func login() {
        if let id = userId.value, DataManager.shared.getPerson(byId: id) != nil {
            LocalStorage.shared.createEntity(id: id)
        }
        Utility.shared.checkCredential()
    }
}

