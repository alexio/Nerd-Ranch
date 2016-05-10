//
//  ViewController.swift
//  WorldTrotter
//
//  Created by Alexio Mota on 5/9/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Double?  {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    let backgroundColors: [UIColor] = [UIColor.orangeColor(),
                                       UIColor.lightGrayColor(),
                                       UIColor.blueColor(),
                                       UIColor.darkGrayColor(),
                                       UIColor.cyanColor(),
                                       UIColor.greenColor(),
                                       UIColor.redColor()]
    var currentBackgroundColorIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view.")
        // Do any additional setup after loading the view, typically from a nib.
//        let firstFrame = CGRect(x: 160, y: 240, width: 100, height: 150)
//        let firstView = UIView(frame: firstFrame)
//        firstView.backgroundColor = UIColor.blueColor()
//        view.addSubview(firstView)
//        
//        let secondFrame = CGRect(x: 20, y: 30, width: 50, height: 50)
//        let secondView = UIView(frame: secondFrame)
//        secondView.backgroundColor = UIColor.greenColor()
//        firstView.addSubview(secondView)
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        <#code#>
//    }
    
    override func viewWillAppear(animated: Bool) {
        currentBackgroundColorIndex += 1
        if (currentBackgroundColorIndex >= backgroundColors.count) {
            currentBackgroundColorIndex = 0
        }
    
        view.backgroundColor = backgroundColors[currentBackgroundColorIndex]
    }
    
    func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        print("Current text: \(textField.text)")
        print("Replacement text: \(string)")
        
        let letters = NSCharacterSet.letterCharacterSet()
        let hasLetters = string.rangeOfCharacterFromSet(letters)

        //check if user is adding more than one decimal separator
//        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(".")
//        let replacementTextHasDecimalSeparator = string.rangeOfString(".")
        
        let currentLocale = NSLocale.currentLocale()
        let decimalSeparator =
            currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
        let existingTextHasDecimalSeparator
            = textField.text?.rangeOfString(decimalSeparator)
        let replacementTextHasDecimalSeparator = string.rangeOfString(decimalSeparator)
        
        
        let hasExtraDecimalSeparator: Bool = existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil
        
        if hasExtraDecimalSeparator || hasLetters != nil {
            return false
        }
        else {
            return true
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, number = numberFormatter.numberFromString(text) {
            fahrenheitValue = number.doubleValue
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

