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
    let popVc = BehaviorRelay<Void>(value: ())
    
    func primaryTap() {
        if let person = newData {
            guard let firstName = firstNameRelay.value, !firstName.isEmpty, !firstName.contains(" ") else {
                showToast.accept("First name cannot be empty or contain spaces")
                return
            }
            
            guard let lastName = lastNameRelay.value, !lastName.isEmpty, !lastName.contains(" ") else {
                showToast.accept("Last name cannot be empty or contain spaces")
                return
            }
            
            if let email = emailRelay.value, !email.isEmpty {
                if !NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) {
                    showToast.accept("Invalid email format")
                }
                return
            }
            
            if newData?.id != nil {
                DataManager.shared.updatePerson(person)
            } else {
                DataManager.shared.addPerson(person)
            }
            showToast.accept("\({newData?.id != nil ? "Update" : "Add"}()) Successfully")
            popVc.accept(())
        }
    }
    
    func secondaryTap() {
        if let id = self.data.value?.id {
            DataManager.shared.deletePerson(byId: id)
            showToast.accept("Deleted")
            popVc.accept(())
        }
    }
}
