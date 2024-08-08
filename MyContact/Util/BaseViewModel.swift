//
//  BaseViewModel.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation
import RxRelay

class BaseViewModel {
    var selectedPerson: BehaviorRelay<Person?> = BehaviorRelay(value: nil)
    
//    init() {
//        print("BaseViewModel initialized with selectedUserId: \(selectedUserId.value ?? "nil")")
//    }
}
