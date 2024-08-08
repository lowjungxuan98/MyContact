//
//  ContactDetailViewModel.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation
import RxRelay

class ContactDetailViewModel: BaseViewModel {
    var data: BehaviorRelay<Person?> = BehaviorRelay(value: nil)
    var newData: Person?
    let firstNameRelay = BehaviorRelay<String?>(value: nil)
    let lastNameRelay = BehaviorRelay<String?>(value: nil)
    let emailRelay = BehaviorRelay<String?>(value: nil)
    let dobRelay = BehaviorRelay<String?>(value: nil)
}
