//
//  ContactDetailViewController.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation
import UIKit
import RxBiBinding

class ContactDetailViewController: BaseViewController<ContactDetailViewModel> {
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(FormTableViewCell.self, forCellReuseIdentifier: "MainInformationForm")
        view.register(FormTableViewCell.self, forCellReuseIdentifier: "SubInformationForm")
        view.register(FormButtonTableViewCell.self, forCellReuseIdentifier: "FormButtonTableViewCell")
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.sectionHeaderTopPadding = .zero
        view.sectionFooterHeight = 0
        view.bouncesVertically = false
        return view
    }()
    
    private let avatarContainer: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalCentering
        view.spacing = 0
        view.heightAnchor.constraint(equalToConstant: 170).isActive = true
        return view
    }()
    
    let avatar: CircleAvatarView = {
        let view = CircleAvatarView()
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var cells: [UITableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Contact Detail")
        
        tableView.dataSource = self
        tableView.delegate = self
        contentView.addSubview(tableView)
        avatarContainer.addArrangedSubview(UIView())
        avatarContainer.addArrangedSubview(avatar)
        avatarContainer.addArrangedSubview(UIView())
        contentView.addSubview(avatarContainer)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -29),
            
            avatarContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        disposeBag.insert(
            viewModel.data.bind(onNext: { person in
                self.viewModel.newData = person
                self.reloadView()
            }),
            viewModel.firstNameRelay.subscribe(onNext: { s in
                self.viewModel.newData?.updateFirstName(s)
            }),
            viewModel.lastNameRelay.subscribe(onNext: { s in
                self.viewModel.newData?.updateLastName(s)
            }),
            viewModel.emailRelay.subscribe(onNext: { s in
                self.viewModel.newData?.updateEmail(s)
            }),
            viewModel.dobRelay.subscribe(onNext: { s in
                self.viewModel.newData?.updateDob(s)
            })
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.data.value?.id == nil {
            viewModel.newData = Person(firstName: viewModel.firstNameRelay.value ?? "", lastName: viewModel.lastNameRelay.value ?? "")
        }
    }
    
    func reloadView() {
        cells.removeAll()
        if let text = viewModel.data.value?.nameShortForm {
            avatar.configure(with: text, font: .systemFont(ofSize: 40))
        }
        let headerView = avatarContainer
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        tableView.tableHeaderView = headerView
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainInformationForm") as? FormTableViewCell {
            let form = MainInformationForm()
            cell.configure(with: form)
            cell.selectionStyle = .none
            disposeBag.insert(
                cell.textField1.textField.rx.text <-> viewModel.firstNameRelay,
                cell.textField2.textField.rx.text <-> viewModel.lastNameRelay
            )
            viewModel.firstNameRelay.accept(viewModel.data.value?.firstName)
            viewModel.lastNameRelay.accept(viewModel.data.value?.lastName)
            cells.append(cell)
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SubInformationForm") as? FormTableViewCell {
            let form = SubInformationForm()
            cell.configure(with: form)
            cell.selectionStyle = .none
            cell.currentDate = viewModel.data.value?.dob
            cell.datePicked = { date in
                self.viewModel.dobRelay.accept(date.toString())
            }
            disposeBag.insert(
                cell.textField1.textField.rx.text <-> viewModel.emailRelay,
                cell.textField2.textField.rx.text <-> viewModel.dobRelay
            )
            viewModel.emailRelay.accept(viewModel.data.value?.email)
            viewModel.dobRelay.accept(viewModel.data.value?.dob)
            cells.append(cell)
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FormButtonTableViewCell") as? FormButtonTableViewCell {
            cell.selectionStyle = .none
            cell.primary.setTitle({
                if viewModel.data.value == nil {
                    "Save"
                } else {
                    "Update"
                }
            }(), for: .normal)
            disposeBag.insert(
                cell.primary.rx.tap
                    .bind { _ in
                        print("abudebug \(String(describing: self.viewModel.newData))")
                        if let person = self.viewModel.newData {
                            if self.validateFields() {
                                if cell.primary.titleLabel?.text == "Update" {
                                    DataManager.shared.updatePerson(person)
                                } else {
                                    DataManager.shared.addPerson(person)
                                }
                                self.showToast("\(cell.primary.titleLabel?.text ?? "") Successfully") { didTap in
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    },
                cell.secondary.rx.tap
                    .bind(onNext: { _ in
                        if let id = self.viewModel.data.value?.id {
                            DataManager.shared.deletePerson(byId: id)
                            self.showToast("Deleted") { didTap in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    })
            )
            cell.secondary.isHidden = viewModel.data.value == nil
            cells.append(cell)
        }
        tableView.reloadData()
    }
    
    func validateFields() -> Bool {
           guard let firstName = viewModel.firstNameRelay.value, !firstName.isEmpty, !firstName.contains(" ") else {
               showToast("First name cannot be empty or contain spaces")
               return false
           }
           
           guard let lastName = viewModel.lastNameRelay.value, !lastName.isEmpty, !lastName.contains(" ") else {
               showToast("Last name cannot be empty or contain spaces")
               return false
           }
           
           if let email = viewModel.emailRelay.value, !email.isEmpty {
               if !isValidEmail(email) {
                   showToast("Invalid email format")
                   return false
               }
           }
           
           return true
       }
       
       func isValidEmail(_ email: String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailTest.evaluate(with: email)
       }
}

extension ContactDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cells[indexPath.row]
    }
}
