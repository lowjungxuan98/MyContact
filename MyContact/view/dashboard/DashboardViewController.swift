//
//  DashboardViewController.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit
import RxBiBinding

class DashboardViewController: BaseViewController<DashboardViewModel> {
    
    private let vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 14, left: 30, bottom: 0, right: 30)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private let searchTextField: PrimaryTextField = {
        let view = PrimaryTextField()
        view.configure(placeholder: "Search your contact list...", trailing: MyImage.shared.icSearch)
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactTableViewCell")
        view.register(ContactHeaderView.self, forHeaderFooterViewReuseIdentifier: ContactHeaderView.reuseIdentifier)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.sectionHeaderTopPadding = .zero
        view.sectionFooterHeight = 0;
        return view
    }()
    
    private let fabButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorPalette.shared.blue_0077B6
        view.layer.cornerRadius = 32.5
        view.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        view.tintColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        view.widthAnchor.constraint(equalToConstant: 65).isActive = true
        view.heightAnchor.constraint(equalToConstant: 65).isActive = true
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setTitle("My Contacts")
        vStack.addArrangedSubview(searchTextField)
        vStack.addArrangedSubview(tableView)
        contentView.addSubview(vStack)
        contentView.addSubview(fabButton)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            fabButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fabButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        disposeBag.insert(
            searchTextField.textField.rx.text <-> viewModel.searchRelay,
            viewModel.data.asObservable().subscribe(onNext: { _ in
                self.tableView.reloadData()
            }),
            viewModel.searchRelay.subscribe(onNext: { _ in
                self.viewModel.search()
            }),
            fabButton.rx.tap.bind(onNext: { _ in
                self.routeToContactDetail()
            })
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.initial()
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.data.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.value?[section].1.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        if let person = viewModel.data.value?[indexPath.section].1[indexPath.row] {
            cell.configure(with: person, isCurrentUser: person.id == LocalStorage.shared.fetchEntities().first?.id)
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactHeaderView.reuseIdentifier) as? ContactHeaderView else {
            return UIView()
        }
        headerView.titleLabel.text = viewModel.data.value?[section].0
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let person = viewModel.data.value?[indexPath.section].1[indexPath.row] {
            viewModel.selectedPerson.accept(person)
        }
    }
}
