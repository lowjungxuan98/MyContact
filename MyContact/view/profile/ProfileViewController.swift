//
//  ProfileViewController.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    private let vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatar: CircleAvatarView = {
        let view = CircleAvatarView()
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = ColorPalette.shared.gray_060326_59
        return view
    }()
    
    private let emailLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = ColorPalette.shared.gray_060326_59
        return view
    }()
    
    private let dobLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = ColorPalette.shared.gray_060326_59
        return view
    }()
    
    private let button: PrimaryButton = {
        let view = PrimaryButton()
        view.setTitle("Update my detail", for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setTitle("My Profile")
        showLogoutButton = true
        
        vStack.addArrangedSubview(avatar)
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(emailLabel)
        vStack.addArrangedSubview(dobLabel)
        contentView.addSubview(vStack)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 34),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            button.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 25),
            button.leadingAnchor.constraint(equalTo: vStack.leadingAnchor, constant: 15),
            button.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: -15),
        ])
        
        disposeBag.insert(
            viewModel.data
                .asObservable()
                .subscribe(onNext: { [weak self] person in
                    if let person = person {
                        self?.avatar.configure(with: person.nameShortForm, font: .systemFont(ofSize: 40))
                        self?.nameLabel.text = "\(person.firstName) \(person.lastName)"
                        self?.emailLabel.text = person.email
                        self?.dobLabel.text = person.dob
                    }
                }),
            button.rx.tap.bind(onNext: { _ in
                self.viewModel.selectedPerson.accept(self.viewModel.data.value)
            })
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.initial()
    }
}
