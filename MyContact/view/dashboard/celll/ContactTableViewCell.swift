import UIKit

class ContactTableViewCell: UITableViewCell {
    
    let hStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatar: CircleAvatarView = {
        let view = CircleAvatarView()
        view.heightAnchor.constraint(equalToConstant: 47).isActive = true
        view.widthAnchor.constraint(equalToConstant: 47).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = ColorPalette.shared.gray_060326_59
        return view
    }()
    
    let youLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .italicSystemFont(ofSize: 15)
        view.textColor = ColorPalette.shared.gray_CCCCCC
        view.text = "(you)"
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
        hStack.addArrangedSubview(avatar)
        hStack.addArrangedSubview(nameLabel)
        hStack.addArrangedSubview(youLabel)
        hStack.setCustomSpacing(3, after: nameLabel)
        hStack.addArrangedSubview(UIView())
        contentView.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    func configure(with person: Person, isCurrentUser: Bool = false) {
        avatar.configure(with: person.nameShortForm, font: .systemFont(ofSize: 20))
        nameLabel.text = (person.firstName) + " " + (person.lastName)
        youLabel.isHidden = !isCurrentUser
    }
}
