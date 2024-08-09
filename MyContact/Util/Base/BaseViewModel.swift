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
    var showToast: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var endToast: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
//    init() {
//        print("BaseViewModel initialized with selectedUserId: \(selectedUserId.value ?? "nil")")
//    }
}
