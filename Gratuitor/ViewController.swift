//
//  ViewController.swift
//  Gratuitor
//
//  Created by Aristotle on 2017-1-15.
//  Copyright © 2016 HLPostman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Currency indicator and converter
    lazy var currencyStatusAndConversionButton: UIButton = {
        let button = UIButton()
        button.setTitle("$", for: .normal)
        button.titleLabel!.font = UIFont(name: "Arial", size: 150)
        button.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.6)
        button.addTarget(self, action: #selector(adjustCurrency), for: .touchUpInside)
        button.addTarget(self, action: #selector(setCurrencyForResultFields), for: .touchUpInside)
        button.addTarget(self, action: #selector(populateTipAndTotalResults), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Currency and Number formatting
    var currencyFormatter: NumberFormatter = {
        let cf = NumberFormatter()
        cf.usesGroupingSeparator = true
        cf.numberStyle = .currency
        return cf
    }()
    
    func adjustCurrency(sender: UIButton) {
        let supportedCurrencies = ["$", "€"]
        let bill = Double(billTextField.text ?? "") ?? 0
        if sender.title(for: .normal) == supportedCurrencies[0] {
            sender.setTitle(supportedCurrencies[1], for: .normal)
            currencyFormatter.locale = Locale(identifier: "en_US")
            billTextField.text = String(format: "%.2f", (0.94077*bill))
        } else {
            sender.setTitle(supportedCurrencies[0], for: .normal)
            currencyFormatter.locale = Locale(identifier: "en_FR")
            billTextField.text = String(format: "%.2f", Double(1.06105*bill))
        }
        print("touched up inside") // Debug
    }
    
    // Bill input area
    lazy var billTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Arial", size: 150)
        tf.minimumFontSize = 30
        tf.adjustsFontSizeToFitWidth = true
        tf.textAlignment = NSTextAlignment.center
        tf.textColor = UIColor(white: 1, alpha: 0.5)
        tf.backgroundColor = UIColor(white: 1, alpha: 0.4)
        // tf.addTarget(self, action: #selector(calculateTip), for: .editingChanged)
        tf.addTarget(self, action: #selector(handleSelectedTipLevel), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Segmented control to select tip percentage by satisfaction
    lazy var tipPercentageSegmentedControl: UISegmentedControl  = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Eh", at: 0, animated: true)
        sc.insertSegment(withTitle: "Good", at: 1, animated: true)
        sc.insertSegment(withTitle: "Awesome", at: 2, animated: true)
        sc.tintColor = UIColor.gray
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleSelectedTipLevel), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    // Result headers
    let splitOneWayHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Just Me"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor(white: 1, alpha: 0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let splitTwoWayHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Us Two"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var splitThreeOrMoreWayHeaderField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Party Of #"
        tf.textAlignment = NSTextAlignment.center
        tf.font = UIFont(name: "Arial", size: 20)
        tf.textColor = UIColor.darkGray
        tf.backgroundColor = UIColor(white: 1, alpha: 0.4)
        tf.addTarget(self, action: #selector(handleSelectedTipLevel), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Tip Result labels
    let splitOneWayResultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.purple
        label.backgroundColor = UIColor(white: 1, alpha: 0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let splitTwoWayResultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.purple
        label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let splitThreeOrMoreWayResultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.purple
        label.backgroundColor = UIColor(white: 1, alpha: 0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Total Result labels
    let splitOneWayTotalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.purple
        label.backgroundColor = UIColor(white: 1, alpha: 0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let splitTwoWayTotalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.purple
        label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let splitThreeOrMoreWayTotalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.purple
        label.backgroundColor = UIColor(white: 1, alpha: 0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Billfield padding
    // Left padding
    let leftPadding: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Right padding
    let rightPadding: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 1, alpha: 0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // Horizontal separator
    let horizontalSeparatorBar: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Vertical separators
    let lefthandSeparator: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let righthandSeparator: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tipLevel = 0.20
    
    var tipAmount: Double {
        let bill = Double(billTextField.text ?? "") ?? 0
        let tip = bill * tipLevel
        return tip
    }
    
    func setCurrencyForResultFields() {
        let supportedCurrencies = ["$", "€"]
        if currencyStatusAndConversionButton.title(for: .normal) == supportedCurrencies[0] {
            currencyFormatter.locale = Locale(identifier: "en_US")
            // print(currencyStatusAndConversionButton.title(for: .normal)! + "is button state")
        } else {
            currencyFormatter.locale = Locale(identifier: "fr_FR")
            // print(currencyStatusAndConversionButton.title(for: .normal)! + "is button state")
        }
    }
    
    func populateTipAndTotalResults() {
        let bill = Double(billTextField.text ?? "") ?? 0
        print(bill) // Debug
        // Tip
        splitOneWayResultLabel.text = currencyFormatter.string(from: NSNumber(value: (tipAmount / 1 )))
        splitTwoWayResultLabel.text = currencyFormatter.string(from: NSNumber(value: (tipAmount / 2)))
        let multiWay = Double(splitThreeOrMoreWayHeaderField.text ?? "") ?? 1
        splitThreeOrMoreWayResultLabel.text = currencyFormatter.string(from: NSNumber(value: (tipAmount / multiWay)))
        
        // Total
        splitOneWayTotalLabel.text = currencyFormatter.string(from: NSNumber(value: bill + tipAmount))
        splitTwoWayTotalLabel.text = currencyFormatter.string(from: NSNumber(value:(bill + tipAmount) / 2))
        splitThreeOrMoreWayTotalLabel.text = currencyFormatter.string(from: NSNumber(value: (bill + tipAmount) / multiWay))
    }
    func handleSelectedTipLevel() {
        let lowTip = 0.15
        let mediumTip = 0.20
        let highTip = 0.25
        switch tipPercentageSegmentedControl.selectedSegmentIndex {
        case 0:
            tipLevel = lowTip
            
        case 1:
            tipLevel = mediumTip
        default:
            tipLevel = highTip
        }
        print("Handled tip selection! 😄") // Debug
        print(tipLevel) // Debug
        populateTipAndTotalResults()
    }
    
    // Keyboard dismiss
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.purple
        self.navigationController?.isNavigationBarHidden = false
        
        // Settings navbar item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettings))
        
        // Dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Setup views
        setupCurrencyButtonAndBillTextField()
        setupTipPercentageSegmentedControl()
        setupResultHeadersAndLabels()
        
        
    }
    
    func calculateTip(_ sender: AnyObject) {
        print("Responding 🙃") // Debug
    }
    
    func goToSettings(){
        let settingsController = SettingsController(nibName: nil, bundle: nil)
        present(UINavigationController(rootViewController: settingsController), animated: true, completion: nil)
    }
    
    func setupCurrencyButtonAndBillTextField() {
        
        // Place Dollar Sign in the view, and add teh x, y, width, and height constraints
        view.addSubview(currencyStatusAndConversionButton)
        currencyStatusAndConversionButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        currencyStatusAndConversionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        currencyStatusAndConversionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        currencyStatusAndConversionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4).isActive = true
        
        // Left padding
        view.addSubview(leftPadding)
        leftPadding.leftAnchor.constraint(equalTo: currencyStatusAndConversionButton.rightAnchor).isActive = true
        leftPadding.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        leftPadding.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leftPadding.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4).isActive = true
        
        // Right padding
        view.addSubview(rightPadding)
        rightPadding.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rightPadding.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        rightPadding.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightPadding.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4).isActive = true
        
        // Place Bill TextField in the view, and add the x, y, width, and height constraints
        view.addSubview(billTextField)
        billTextField.leftAnchor.constraint(equalTo: leftPadding.rightAnchor).isActive = true
        billTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        billTextField.rightAnchor.constraint(equalTo: rightPadding.leftAnchor).isActive = true
        billTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4).isActive = true
        
        //  Horizontal separator bar
        view.addSubview(horizontalSeparatorBar)
        horizontalSeparatorBar.topAnchor.constraint(equalTo: billTextField.bottomAnchor).isActive = true
        horizontalSeparatorBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        horizontalSeparatorBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupTipPercentageSegmentedControl() {
        // Place in the view, and add the x, y, width, and height constraints
        view.addSubview(tipPercentageSegmentedControl)
        tipPercentageSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tipPercentageSegmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tipPercentageSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        tipPercentageSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupResultHeadersAndLabels() {
        
        // Headers
        // Place One-Way header label in the view, and add the x, y, width, and height constraints
        view.addSubview(splitOneWayHeaderLabel)
        splitOneWayHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        splitOneWayHeaderLabel.topAnchor.constraint(equalTo: horizontalSeparatorBar.bottomAnchor).isActive = true
        splitOneWayHeaderLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitOneWayHeaderLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        // Place Two-Way header label in the view, and add the x, y, width, and height constraints
        view.addSubview(splitTwoWayHeaderLabel)
        splitTwoWayHeaderLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        splitTwoWayHeaderLabel.topAnchor.constraint(equalTo: splitOneWayHeaderLabel.bottomAnchor).isActive = true
        splitTwoWayHeaderLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitTwoWayHeaderLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        // Place Multi-Way header field in the view, and add the x, y, width, and height constraints
        view.addSubview(splitThreeOrMoreWayHeaderField)
        splitThreeOrMoreWayHeaderField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        splitThreeOrMoreWayHeaderField.topAnchor.constraint(equalTo: splitTwoWayHeaderLabel.bottomAnchor).isActive = true
        splitThreeOrMoreWayHeaderField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitThreeOrMoreWayHeaderField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        
        // Vertical separator
        view.addSubview(lefthandSeparator)
        lefthandSeparator.leftAnchor.constraint(equalTo: splitOneWayHeaderLabel.rightAnchor).isActive = true
        lefthandSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        lefthandSeparator.topAnchor.constraint(equalTo: horizontalSeparatorBar.topAnchor).isActive = true
        lefthandSeparator.bottomAnchor.constraint(equalTo: splitThreeOrMoreWayHeaderField.bottomAnchor).isActive = true
        
        // Tips
        // Place One-Way result label in the view, and add the x, y, width, and height constraints & initial value
        view.addSubview(splitOneWayResultLabel)
        splitOneWayResultLabel.text = currencyFormatter.string(from: 0)
        splitOneWayResultLabel.leftAnchor.constraint(equalTo: lefthandSeparator.rightAnchor).isActive = true
        splitOneWayResultLabel.topAnchor.constraint(equalTo: horizontalSeparatorBar.bottomAnchor).isActive = true
        splitOneWayResultLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitOneWayResultLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        // Place Two-Way result label in the view, and add the x, y, width, and height constraints & initial value
        view.addSubview(splitTwoWayResultLabel)
        splitTwoWayResultLabel.text = currencyFormatter.string(from: 0)
        splitTwoWayResultLabel.leftAnchor.constraint(equalTo: lefthandSeparator.rightAnchor).isActive = true
        splitTwoWayResultLabel.topAnchor.constraint(equalTo: splitOneWayResultLabel.bottomAnchor).isActive = true
        splitTwoWayResultLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitTwoWayResultLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        // Place Multi-Way result label in the view, and add the x, y, width, and height constraints & initial value
        view.addSubview(splitThreeOrMoreWayResultLabel)
        splitThreeOrMoreWayResultLabel.text = currencyFormatter.string(from: 0)
        splitThreeOrMoreWayResultLabel.leftAnchor.constraint(equalTo: lefthandSeparator.rightAnchor).isActive = true
        splitThreeOrMoreWayResultLabel.topAnchor.constraint(equalTo: splitTwoWayResultLabel.bottomAnchor).isActive = true
        splitThreeOrMoreWayResultLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitThreeOrMoreWayResultLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        
        // Vertical separator
        view.addSubview(righthandSeparator)
        righthandSeparator.leftAnchor.constraint(equalTo: splitOneWayResultLabel.rightAnchor).isActive = true
        righthandSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        righthandSeparator.topAnchor.constraint(equalTo: horizontalSeparatorBar.bottomAnchor).isActive = true
        righthandSeparator.bottomAnchor.constraint(equalTo: splitThreeOrMoreWayResultLabel.bottomAnchor).isActive = true
        
        // Totals
        // One-Way Total
        view.addSubview(splitOneWayTotalLabel)
        splitOneWayTotalLabel.text = currencyFormatter.string(from: 0)
        splitOneWayTotalLabel.leftAnchor.constraint(equalTo: righthandSeparator.rightAnchor).isActive = true
        splitOneWayTotalLabel.topAnchor.constraint(equalTo: horizontalSeparatorBar.bottomAnchor).isActive = true
        splitOneWayTotalLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitOneWayTotalLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        // Two-Way Total
        view.addSubview(splitTwoWayTotalLabel)
        splitTwoWayTotalLabel.text = currencyFormatter.string(from: 0)
        splitTwoWayTotalLabel.leftAnchor.constraint(equalTo: righthandSeparator.rightAnchor).isActive = true
        splitTwoWayTotalLabel.topAnchor.constraint(equalTo: splitOneWayTotalLabel.bottomAnchor).isActive = true
        splitTwoWayTotalLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitTwoWayTotalLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        // Multi-Way Total
        view.addSubview(splitThreeOrMoreWayTotalLabel)
        splitThreeOrMoreWayTotalLabel.text = currencyFormatter.string(from: 0)
        splitThreeOrMoreWayTotalLabel.leftAnchor.constraint(equalTo: righthandSeparator.rightAnchor).isActive = true
        splitThreeOrMoreWayTotalLabel.topAnchor.constraint(equalTo: splitTwoWayTotalLabel.bottomAnchor).isActive = true
        splitThreeOrMoreWayTotalLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        splitThreeOrMoreWayTotalLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/12).isActive = true
        
    }
    
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
