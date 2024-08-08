//
//  ContactDetailViewController.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation

class ContactDetailViewController: BaseViewController<ContactDetailViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Contact Detail")
        print("abudebug \(viewModel.data)")
    }
}
