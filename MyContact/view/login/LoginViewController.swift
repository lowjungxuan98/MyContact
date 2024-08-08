//
//  LoginViewController.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxBiBinding

class LoginViewController: BaseViewController<LoginViewModel> {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Hi There!"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = ColorPalette.shared.blue_0077B6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Please login to see your contact list"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = ColorPalette.shared.gray_CCCCCC
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let idTextField: PrimaryTextField = {
        let view = PrimaryTextField()
        view.configure(labelText: "User ID" ,placeholder: "Enter Your User ID", leading: MyImage.shared.icPerson)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let button: PrimaryButton = {
        let view = PrimaryButton()
        view.setTitle("Login", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(idTextField)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 53),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            idTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 39),
            idTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            idTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            button.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 45),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
        ])
        
        disposeBag.insert(
            idTextField.textField.rx.text <-> viewModel.userId,
            button.rx.tap.bind(onNext: { _ in
                self.viewModel.login()
            })
        )
    }
}
