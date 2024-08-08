//
//  BaseViewController.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import Toast_Swift

class BaseViewController<VM>: UIViewController where VM: BaseViewModel {
    
    var viewModel: VM
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let navigationBar: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.spacing = 32
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private let backBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(MyImage.shared.icBack, for: .normal)
        view.widthAnchor.constraint(equalToConstant: 18).isActive = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 23, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    private let logoutBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Logout", for: .normal)
        view.setTitleColor(ColorPalette.shared.blue_0077B6, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    var showLogoutButton: Bool = false {
        didSet {
            if showLogoutButton {
                if !navigationBar.arrangedSubviews.contains(logoutBtn) {
                    navigationBar.addArrangedSubview(logoutBtn)
                }
            } else {
                if navigationBar.arrangedSubviews.contains(logoutBtn) {
                    navigationBar.removeArrangedSubview(logoutBtn)
                    logoutBtn.removeFromSuperview()
                }
            }
        }
    }
    
    var showNavBar: Bool = true {
        didSet {
            navigationBar.isHidden = !showNavBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationBar.addArrangedSubview(backBtn)
        }
        navigationBar.addArrangedSubview(titleLabel)
        mainView.addArrangedSubview(navigationBar)
        mainView.addArrangedSubview(contentView)
        view.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        disposeBag.insert(
            logoutBtn.rx.tap
                .bind { _ in
                    let entities = LocalStorage.shared.fetchEntities()
                    if let id = entities.first?.id {
                        LocalStorage.shared.deleteEntity(id: id)
                        Utility.shared.checkCredential()
                    }
                },
            backBtn.rx.tap
                .bind(onNext: { _ in
                    self.navigationController?.popViewController(animated: true)
                }),
            viewModel.selectedPerson
                .skip(1)
                .subscribe(onNext: { _ in
                self.routeToContactDetail()
            })
        )
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func showToast(_ s: String, completion: ((_ didTap: Bool) -> Void)? = nil) {
        self.view.makeToast(s, duration: 1.0, position: .center, style: ToastStyle(), completion: completion)
    }
}

extension BaseViewController {
    func routeToContactDetail() {
        let vm = ContactDetailViewModel()
        vm.data = viewModel.selectedPerson
        let vc = ContactDetailViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
