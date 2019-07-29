//
//  ViewController.swift
//  CowryWiseCal
//
//  Created by Peter Oriola on 19/07/2019.
//  Copyright © 2019 Peter Oriola. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ADCountryPicker

class CurrencyCalViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //Data Types
    var countryCurrency = ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTC", "BTN", "BWP", "BYN", "BYR", "BZD", "CAD", "CDF", "CHF", "CLF", "CLP", "CNY", "COP", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "STD", "SVC", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPF", "YER", "ZAR", "ZMK", "ZMW", "ZWL"]

    
    enum CardState {
        case expanded
        case collapsed
        
    }
    
    //MARK: ViewControlller Outlets
    @IBOutlet weak var countryATextField: UITextField!
    @IBOutlet weak var countryBTextField: UITextField!
    @IBOutlet weak var countryFlagA: UITextField!
    @IBOutlet weak var countryFlagB: UITextField!
    @IBOutlet weak var convertionButtonTapped: UIButton!
    @IBOutlet weak var middayLabel: UILabel!
    
    //Networking DataTypes
    var convertUrl = ""
    let apiKey = "ae742829063e96d0dced16f68778b5d7"
    var lastestUrl = ""
    
    //BottomDrawer DataTypes
    var drawerViewController : DrawerViewController!
    var VisulaEffectView : UIVisualEffectView!
    var cardVisible = false
    
    let buttonDrawerHeight : CGFloat = 600
    let buttonHandleAreaHeight : CGFloat = 150
    
    var currentTextField: UITextField?
    
    var drawerView = DrawerViewController()
    
    var nextState : CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted : CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      setupCard()

        countryPickerToolBAR()

       
         countryFlagA.text  = "EUR"
        countryFlagB.text  = countryCurrency.first
        textFieldRightSideText1()
        textFieldRightSideText2()
        
        countryATextField.text = "1"
    }
    
    //Add ToolBar to the Date Picker
    func countryPickerToolBAR() {
        let thePicker = UIPickerView()
       // countryFlagA.inputView = thePicker
        countryFlagB.inputView = thePicker
        thePicker.delegate = self
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        //countryFlagA.delegate = self
        countryFlagB.delegate = self
       // countryFlagA.inputAccessoryView = toolbar
        //countryFlagA.inputView = thePicker
        countryFlagB.inputAccessoryView = toolbar
        countryFlagB.inputView = thePicker
}
    @objc func donedatePicker(){
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        

        
    }
    
    //MARK:- PickerView Delegate manipulations
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryCurrency.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryCurrency[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                    countryFlagB.text = countryCurrency[row]

//            if let currentTextField = currentTextField {
//                currentTextField.text = countryCurrency[row]
//                currentTextField.resignFirstResponder()
//                self.currentTextField = nil
//            }
        if countryCurrency[row] == countryFlagA.text {
        textFieldRightSideText1()
        
        }else if countryCurrency[row] == countryFlagB.text {
            textFieldRightSideText2()
        }
        

        
    }
    
    //MMARK: TextFields Delegaates Mmanipulation
    func textFieldRightSideText1() {
        
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 36))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 36))
        label.text = "EUR"
        label.textColor = UIColor.gray
        label.textAlignment = .right
        rightView.addSubview(label)
        
        countryATextField.rightView = rightView
        countryATextField.rightViewMode = .always
        
        
        print(countryFlagA.text ?? "No Country")
    }
    func textFieldRightSideText2() {
        
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 36))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 36))
        label.text = countryFlagB.text
        label.textColor = UIColor.gray
        label.textAlignment = .right
        rightView.addSubview(label)
        
        countryBTextField.rightView = rightView
        countryBTextField.rightViewMode = .always
        
        
        print(countryFlagA.text ?? "No Country")
    }
    

    //MMARK BottomDrawer Animations
    func setupCard() {
        
        VisulaEffectView = UIVisualEffectView()
        //VisulaEffectView.frame = self.view.frame
        self.view.addSubview(VisulaEffectView)
        
        drawerViewController = DrawerViewController(nibName: "DrawerViewController", bundle: nil)
        
        self.addChild(drawerViewController)
        self.view.addSubview(drawerViewController.view)
        
        drawerViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - buttonHandleAreaHeight, width: self.view.bounds.width, height: buttonDrawerHeight)
        
        drawerViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CurrencyCalViewController.handleCardTap(recognizer:)))
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CurrencyCalViewController.handleCardPan(recognizer:)))
        
        drawerViewController.handleAreaView.addGestureRecognizer(tapGestureRecognizer)
        drawerViewController.handleAreaView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    
    @objc func handleCardTap(recognizer : UITapGestureRecognizer) {
        
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeed(state: nextState, duration: 0.9)
            
        default:
            break
        }
    }
    
    
    @objc func handleCardPan(recognizer : UIPanGestureRecognizer) {
        switch recognizer.state  {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.drawerViewController.handleAreaView)
            
            var franctionComplete = translation.y / buttonDrawerHeight
            franctionComplete = cardVisible ? franctionComplete : -franctionComplete
            updateInteractiveTransition(fractionCompleted: franctionComplete)
            
        case .ended:
            continueInteractiveTransition()
            
        default:
            break
        }
        
    }
    
    
    
    func animateTransitionIfNeed(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.drawerViewController.view.frame.origin.y = self.view.frame.height - self.buttonDrawerHeight
                case .collapsed:
                    self.drawerViewController.view.frame.origin.y = self.view.frame.height - self.buttonHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                    
                case .expanded:
                    self.drawerViewController.view.layer.cornerRadius = 20
                case .collapsed:
                    self.drawerViewController.view.layer.cornerRadius = 0
                    
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
        }
        
        
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeed(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat)
    {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
        
    }
    
    
    //MARK:-- NETWORKING WITHH ALAMOFOIRE AND SWIFTY JSON
            func getConvetCurrencyData(url: String) {
            Alamofire.request(url, method: .get)
            .responseJSON { respose in
            if respose.result.isSuccess {
            
            print("Got the currency convertionRate rates")
            
            let currencyJSON : JSON = JSON(respose.result.value!)
            
            print(currencyJSON)
            
            self.updateLiveConvertedCurrency(json: currencyJSON)
            } else {
           
            
            self.countryBTextField.text = "Connection Issues"
            }
            }
              
    }
    
    
    //MARK: - JSON PARSING
    
    func updateLiveConvertedCurrency(json: JSON) {
        
        if let data:[String: JSON] = json["rates"].dictionaryValue {

            for item in data {
                print(item.value)

                countryBTextField.text = "\(item.value)"
                }
            
            let dataDate = json["date"]
             middayLabel.text = "Mid Market Exchange Rate at \(dataDate)"
        }

        else {
            countryBTextField.text = "Price Unavaliable"
        }
        
        
    }
    
    
    @IBAction func convertTapped(_ sender: Any) {
        
        convertUrl = "http://data.fixer.io/api/convert?access_key=\(apiKey)&from=\(countryFlagA.text!)&to=\(countryFlagB.text!)&amount=\(countryATextField.text!)"
        
        lastestUrl = "http://data.fixer.io/api/latest?access_key=\(apiKey)&base=EUR&symbols=\(countryFlagB.text!)"
        
        getConvetCurrencyData(url: lastestUrl)
        print(convertUrl)
        
        drawerView.dayStats = middayLabel.text!
    }
}



