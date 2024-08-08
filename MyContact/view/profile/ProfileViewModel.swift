//
//  ProfileViewModel.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation
import RxRelay

class ProfileViewModel: BaseViewModel {
    var data: BehaviorRelay<Person?> = BehaviorRelay(value: nil)

    func initial() {
        if let id = LocalStorage.shared.fetchEntities().first?.id, let person = DataManager.shared.getPerson(byId: id) {
            data.accept(person)
        }
    }
}
