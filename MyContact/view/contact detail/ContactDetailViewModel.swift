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
}
