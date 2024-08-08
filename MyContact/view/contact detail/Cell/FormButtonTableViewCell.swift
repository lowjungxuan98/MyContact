//
//  FormButtonTableViewCell.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation
import UIKit

class FormButtonTableViewCell: UITableViewCell {
    
    let vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 27
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let primary: PrimaryButton = {
        let view = PrimaryButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondary: UIButton = {
        let view = UIButton()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.cornerRadius = 10
        view.setTitleColor(.red, for: .normal)
        view.setTitle("Remove", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.heightAnchor.constraint(equalToConstant: 53).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        vStack.addArrangedSubview(primary)
        vStack.addArrangedSubview(secondary)
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -27),
        ])
    }
}
