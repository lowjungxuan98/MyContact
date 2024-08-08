//
//  DashboardViewModel.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation
import RxRelay

class DashboardViewModel: BaseViewModel {
    var searchRelay: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var data: BehaviorRelay<[(String, [Person])]?> = BehaviorRelay(value: nil)

    func initial() {
        if let persons = DataManager.shared.readData()?.sorted(by: { $0.key < $1.key }) {
            data.accept(persons)
        } else {
            print("No data available.")
        }
    }
    
    func search() {
        guard let search = searchRelay.value else { return }
        if search.isEmpty {
            initial()
        } else {
            data.accept(DataManager.shared.searchPersons(with: search).sorted(by: { $0.key < $1.key }))
        }
    }
}
