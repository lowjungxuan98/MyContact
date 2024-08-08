//
//  FormTableViewCell.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation
import UIKit

protocol FormType {
    func title() -> String
    
    func label1() -> String
    func placeholder1() -> String
    func icon1() -> UIImage
    func required1() -> Bool
    
    func label2() -> String
    func placeholder2() -> String
    func icon2() -> UIImage
    func required2() -> Bool
}

extension FormType {
    func required1() -> Bool {
        return true
    }
    
    func required2() -> Bool {
        return true
    }
}

class MainInformationForm: FormType {
    func title() -> String {
        "Main Information"
    }
    
    func label1() -> String {
        "First Name"
    }
    
    func placeholder1() -> String {
        "Enter Your First Name"
    }
    
    func icon1() -> UIImage {
        MyImage.shared.icPerson
    }
    
    func label2() -> String {
        "Last Name"
    }
    
    func placeholder2() -> String {
        "Enter Your Last Name"
    }
    
    func icon2() -> UIImage {
        MyImage.shared.icPerson
    }
}

class SubInformationForm: FormType {
    func title() -> String {
        "Sub Information"
    }
    
    func label1() -> String {
        "Email"
    }
    
    func placeholder1() -> String {
        "Enter Your Email"
    }
    
    func icon1() -> UIImage {
        MyImage.shared.icEmail
    }
    
    func required1() -> Bool {
        false
    }
    
    func label2() -> String {
        "Date of Birth"
    }
    
    func placeholder2() -> String {
        "Enter Your Date of Birth"
    }
    
    func icon2() -> UIImage {
        MyImage.shared.icCalendar
    }
    
    func required2() -> Bool {
        false
    }
}

class FormTableViewCell: UITableViewCell {
    
    let vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 17
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.italicSystemFont(ofSize: 15)
        view.textColor = ColorPalette.shared.blue_0077B6
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorPalette.shared.gray_CCCCCC
        return view
    }()
    
    let textField1: PrimaryTextField = {
        let view = PrimaryTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField2: PrimaryTextField = {
        let view = PrimaryTextField()
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
        vStack.addArrangedSubview(titleLabel)
        vStack.setCustomSpacing(7, after: titleLabel)
        vStack.addArrangedSubview(line)
        vStack.setCustomSpacing(10, after: line)
        vStack.addArrangedSubview(textField1)
        vStack.addArrangedSubview(textField2)
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5),
            
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    func configure(with form: FormType) {
        titleLabel.text = form.title()
        textField1.configure(
            labelText: form.label1(),
            placeholder: form.placeholder1(),
            leading: form.icon1(),
            required: form.required2()
        )        
        textField2.configure(
            labelText: form.label2(),
            placeholder: form.placeholder2(),
            leading: form.icon2(),
            required: form.required2()
        )
    }
}
