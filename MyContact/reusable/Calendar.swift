//
//  Calendar.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import UIKit
import SwiftDate

public class CustomizePopupDatePickerView: UIView {
    
    private var pickerViewBottomConstraint: NSLayoutConstraint!
    private var doneHandler: ((Date) -> ())?

    public var customDatePickerView: CustomDatePickerView!
    public var doneButton: UIButton!
    public var cancelButton: UIButton!
    public var headerView: UIView!
    public var defaultDate: Date = Date()
    //MARK: - Init
    
    public init(_ defaultDate: Date) {
        super.init(frame: .zero)
        self.defaultDate = defaultDate
        setup()
        setupCustomDatePickerView()
        setupHeaderView()
        setupCancelArea()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Setup
     
     private func setup() {
         backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
     }
     
    private func setupCustomDatePickerView() {
        
        customDatePickerView = CustomDatePickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 308))
        customDatePickerView.selectedDate = defaultDate
        customDatePickerView.setupDefaultDate(defaultDate: defaultDate)
        addSubview(customDatePickerView)
        customDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerViewBottomConstraint = customDatePickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 500)
        pickerViewBottomConstraint.isActive = true
        customDatePickerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        customDatePickerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        customDatePickerView.heightAnchor.constraint(equalToConstant: 308).isActive = true

        customDatePickerView.backgroundColor = #colorLiteral(red: 0.231487304, green: 0.2311009765, blue: 0.2485594451, alpha: 1)
    }

     private func setupHeaderView() {
         headerView = UIView(frame: .zero)
         addSubview(headerView)
         headerView.translatesAutoresizingMaskIntoConstraints = false
         headerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
         headerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
         headerView.bottomAnchor.constraint(equalTo: customDatePickerView.topAnchor).isActive = true
         headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
         headerView.backgroundColor = #colorLiteral(red: 0.231487304, green: 0.2311009765, blue: 0.2485594451, alpha: 1)
         
         doneButton = UIButton(type: .system)
         headerView.addSubview(doneButton)
         doneButton.translatesAutoresizingMaskIntoConstraints = false
         doneButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16).isActive = true
         doneButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
         doneButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
         doneButton.setTitle("Done", for: .normal)
         doneButton.tintColor = .red
         doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
         
         cancelButton = UIButton(type: .system)
         headerView.addSubview(cancelButton)
         cancelButton.translatesAutoresizingMaskIntoConstraints = false
         cancelButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
         cancelButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
         cancelButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
         cancelButton.setTitle("Cancel", for: .normal)
         cancelButton.tintColor = .red
         cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
     }
     
     private func setupCancelArea() {
         let cancelAreaButton = UIButton(frame: .zero)
         addSubview(cancelAreaButton)
         cancelAreaButton.translatesAutoresizingMaskIntoConstraints = false
         cancelAreaButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
         cancelAreaButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
         cancelAreaButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
         cancelAreaButton.bottomAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
         cancelAreaButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
     }
    
    //MARK: - Action
    
    @objc private func done() {
        doneHandler?(customDatePickerView.selectedDate)
        doneHandler = nil
        dismissAnimation()
    }

    @objc private func cancel() {
        doneHandler = nil
        dismissAnimation()
    }
    
    //MARK: - Display & Dismiss
    
    private func addToKeyWindow() {
        guard let keyWindow = UIWindow.keyWindow else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        keyWindow.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: keyWindow.topAnchor),
            leftAnchor.constraint(equalTo: keyWindow.leftAnchor),
            bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            rightAnchor.constraint(equalTo: keyWindow.rightAnchor)
        ])
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func display(doneHandler: @escaping ((Date) -> Void)) {
        self.doneHandler = doneHandler
        addToKeyWindow()
        displayAnimation()
    }

    private func displayAnimation() {
        pickerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    private func dismissAnimation() {
        pickerViewBottomConstraint.constant = 500
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
}

public class CustomDatePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerView: UIPickerView!
    var years: [Int] = []
    var months: [Int] = []
    var days: [Int] = []
    var selectedDate: Date = Date() {
        didSet {
            self.dateUpdate()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickerView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPickerView()
    }

    private func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        self.addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalPadding: CGFloat = 30
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func dateUpdate() {
        let date = DateInRegion(year: selectedDate.year, month: selectedDate.month, day: 1)
        let today = Date.now
        years = Array(today.year - 100 ... today.year - 21)

        let isTwentyOneYearsAgo = selectedDate.year == (today.year - 21)
        months = Array(1...(isTwentyOneYearsAgo ? today.month : 12))
        days = Array(1...(isTwentyOneYearsAgo && selectedDate.month == today.month ? today.day : date.monthDays))
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(years.firstIndex(of: selectedDate.year) ?? 0, inComponent: 0, animated: false)
        pickerView.selectRow(months.firstIndex(of: selectedDate.month) ?? 0, inComponent: 1, animated: false)
        pickerView.selectRow(days.firstIndex(of: selectedDate.day) ?? 0, inComponent: 2, animated: false)
    }
    
    public func setupDefaultDate(defaultDate: Date) {
        selectedDate = defaultDate
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            years.count
        case 1:
            months.count
        case 2:
            days.count
        default:
            0
        }
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.text = {
            switch component {
            case 0: // Year
                "\(years[row])"
            case 1: // Month
                String(months[row])
            case 2: // Day
                "\(days[row])"
            default:
                ""
            }
        }()
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = UIColor.white
        return label
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = years[pickerView.selectedRow(inComponent: 0)]
        dateComponents.month = months[pickerView.selectedRow(inComponent: 1)]
        dateComponents.day = days[pickerView.selectedRow(inComponent: 2)]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        selectedDate = calendar.date(from: dateComponents)!
    }
        
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // Assuming the picker view has 3 components: Year, Month, Day
        let totalWidth = pickerView.bounds.width
        switch component {
        case 0: // Year
            return totalWidth * 0.28 // 25% of total width
        case 1: // Month
            return totalWidth * 0.44 // 50% of total width
        case 2: // Day
            return totalWidth * 0.28 // 25% of total width
        default:
            return 0
        }
    }

}
extension UIWindow {
    static var keyWindow: UIWindow? {
        var keyWindow: UIWindow?
        if #available(iOS 13, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        return keyWindow
    }
}
