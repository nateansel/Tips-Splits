//
//  ViewController.swift
//  tips
//
//  Created by Nathan Ansel on 12/2/15.
//  Copyright © 2015 Nathan Ansel. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: Views
  @IBOutlet weak var tipView:               UIView!
  @IBOutlet weak var scrollView:            UIScrollView!
  @IBOutlet weak var SettingsContainerView: UIView!
  
  // MARK: Constraints
  @IBOutlet weak var tipViewConstraint:              NSLayoutConstraint!
  @IBOutlet weak var tipViewHeight:                  NSLayoutConstraint!
  @IBOutlet weak var tipPercentBottomConstraint:     NSLayoutConstraint!
  @IBOutlet weak var settingsButtonBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var scrollViewHeight:               NSLayoutConstraint!
  
  // MARK: Input controls
  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipAmount: UISegmentedControl!
  
  // MARK: Labels
  @IBOutlet weak var tipLabel:              UILabel!
  @IBOutlet weak var totalLabel:            UILabel!
  @IBOutlet weak var currencyLabel:         UILabel!
  @IBOutlet weak var twoPersonSplitLabel:   UILabel!
  @IBOutlet weak var threePersonSplitLabel: UILabel!
  @IBOutlet weak var fourPersonSplitLabel:  UILabel!
  @IBOutlet weak var fivePersonSplitLabel:  UILabel!
  
  // MARK: Miscellanious variables
  let sharedDefaults    = UserDefaults()
  var keyboardHeight    = CGFloat()
  var animationDuration = NSNumber()
  var animationOptions  = UIViewAnimationOptions.curveEaseIn
  
  // MARK: - Methods
  
  // MARK: View Loading
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.changeColorScheme(_:)), name: NSNotification.Name(rawValue: "colorSchemeChanged"), object: nil)

    currencyLabel.text = NumberFormatter().currencySymbol
    
    tipLabel.text = "$0.00"
    totalLabel.text = "$0.00"
    
    
    sharedDefaults.set(true, forKey: "refreshTipValues")
    tipAmount.selectedSegmentIndex = sharedDefaults.integer(forKey: "defaultTipIndex")
    UIApplication.shared.statusBarStyle = .lightContent
    NotificationCenter.default.post(name: Notification.Name(rawValue: "colorSchemeChanged"), object: nil)
    
    billField.font             = UIFont.monospacedDigitSystemFont(ofSize: billField.font!.pointSize,             weight: UIFontWeightThin)
    tipLabel.font              = UIFont.monospacedDigitSystemFont(ofSize: tipLabel.font!.pointSize,              weight: UIFontWeightThin)
    totalLabel.font            = UIFont.monospacedDigitSystemFont(ofSize: totalLabel.font!.pointSize,            weight: UIFontWeightThin)
    twoPersonSplitLabel.font   = UIFont.monospacedDigitSystemFont(ofSize: twoPersonSplitLabel.font!.pointSize,   weight: UIFontWeightThin)
    threePersonSplitLabel.font = UIFont.monospacedDigitSystemFont(ofSize: threePersonSplitLabel.font!.pointSize, weight: UIFontWeightThin)
    fourPersonSplitLabel.font  = UIFont.monospacedDigitSystemFont(ofSize: fourPersonSplitLabel.font!.pointSize,  weight: UIFontWeightThin)
    fivePersonSplitLabel.font  = UIFont.monospacedDigitSystemFont(ofSize: fivePersonSplitLabel.font!.pointSize,  weight: UIFontWeightThin)
  }
  
  
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let appLastOpen = sharedDefaults.object(forKey: "appExitDate") as! Date? {
      print("comparing")
      if Date().compare(appLastOpen) == .orderedAscending {
        billField.text = sharedDefaults.string(forKey: "appExitBillAmount")
      }
      else {
        billField.text = ""
      }
    }
    tipViewConstraint.constant = view.frame.size.height
    textFieldChange(self)
  }
  
  
  
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    billField.becomeFirstResponder()
  }
  
  
  
  // MARK: Notification listeners
  
  ///
  ///  Activates when the keyboard is about to be shown. Sets the height of
  ///  tipView and scrollView, and updates the selected index of tipAmount.
  ///
  /// - author: Nathan Ansel
  /// - parameter notifaction: An NSNotification activated when the keyboard
  ///                           will appear on screen.
  ///
  func keyboardWillShow(_ notification: Notification) {
    let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    keyboardHeight = keyboardFrame.height
    tipViewHeight.constant = view.frame.size.height - (keyboardHeight + 8 + billField.frame.size.height + UIApplication.shared.statusBarFrame.size.height)
    scrollViewHeight.constant = tipViewHeight.constant - 46
    if sharedDefaults.bool(forKey: "refreshDefaultTip") {
      tipAmount.selectedSegmentIndex = sharedDefaults.integer(forKey: "defaultTipIndex")
      sharedDefaults.set(false, forKey: "refreshDefaultTip")
    }
    changeTipAmountTitles()
  }
  
  ///  Animates the change of the color scheme. Uses the colorIndex (a value set
  ///  in the settings) to determine which color scheme to animate to.
  ///
  /// - author: Nathan Ansel
  /// - parameter notification: An NSNotification activated when the color
  ///                            scheme needs to be changed.
  ///
  func changeColorScheme(_ notification: Notification) {
    let colorIndex = sharedDefaults.integer(forKey: "colorSchemeIndex")
    switch colorIndex {
      case 0:
        let blueColor      = UIColor(red:0.23, green:0.45, blue:0.74, alpha:1)
        let lightBlueColor = UIColor(red:0.49, green:0.75, blue:1, alpha:1)
        UIView.animate(withDuration: 0.25,
          animations: { [unowned self] in
            self.tipView.backgroundColor               = blueColor
            self.SettingsContainerView.backgroundColor = lightBlueColor
        })
      case 1:
        let orangeColor      = UIColor(red:1, green:0.47, blue:0.2, alpha:1)
        let lightOrangeColor = UIColor(red:1, green:0.81, blue:0.18, alpha:1)
        UIView.animate(withDuration: 0.25,
          animations: { [unowned self] in
            self.tipView.backgroundColor               = orangeColor
            self.SettingsContainerView.backgroundColor = lightOrangeColor
        })
      default:
        print("ERROR: Color Scheme not changed")
    }
  }
  
  // MARK: Animations
  
  ///  Animates the tipView sliding up onto the screen, or down off the screen.
  ///
  /// - author: Nathan Ansel
  /// - parameter up: A boolean value determining if the tipView needs to
  ///                  animate up or down
  ///
  func animateTipView(up: Bool) {
    if up {
      if tipViewConstraint.constant != 8 {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        UIView.animate(withDuration: 0.3,
          animations: { [unowned self] in
            self.tipViewConstraint.constant = 8
            self.view.layoutIfNeeded()
        })
      }
    } else {
      if tipViewConstraint.constant == 8 {
        UIView.animate(withDuration: 0.3,
          animations: { [unowned self] in
            self.tipViewConstraint.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        })
      }
    }
  }
  
  
  
  
  ///
  ///  Changes the tip amount titles to match the values held in NSUserDefaults
  ///
  /// - author: Nathan Ansel
  ///
  func changeTipAmountTitles() {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    
    if sharedDefaults.bool(forKey: "refreshTipValues") {
      if sharedDefaults.double(forKey: "leftStepperValue") != 0 {
        tipAmount.setTitle(formatter.string(from: NSNumber(value: sharedDefaults.double(forKey: "leftStepperValue"))), forSegmentAt: 0)
      }
      else {
        sharedDefaults.set(0.18, forKey: "leftStepperValue")
        tipAmount.setTitle("18%", forSegmentAt: 0)
      }
      
      if sharedDefaults.double(forKey: "centerStepperValue") != 0 {
        tipAmount.setTitle(formatter.string(from: NSNumber(value: sharedDefaults.double(forKey: "centerStepperValue"))), forSegmentAt: 1)
      }
      else {
        sharedDefaults.set(0.20, forKey: "centerStepperValue")
        tipAmount.setTitle("20%", forSegmentAt: 1)
      }
      
      if sharedDefaults.double(forKey: "rightStepperValue") != 0 {
        tipAmount.setTitle(formatter.string(from: NSNumber(value: sharedDefaults.double(forKey: "rightStepperValue"))), forSegmentAt: 2)
      }
      else {
        sharedDefaults.set(0.25, forKey: "rightStepperValue")
        tipAmount.setTitle("25%", forSegmentAt: 2)
      }
      sharedDefaults.set(false, forKey: "refreshTipValues")
    }
  }

  
  
  
  
  // MARK: Listen for edits
  
  ///
  ///  Activated whenever the value in textField is changed. Updates all the
  ///  values held in tipView that show the user the tip value, total value, and
  ///  all of the split values.
  ///
  /// - author: Nathan Ansel
  /// - parameter sender: Any object that calls this method. Cannot be nil.
  @IBAction func textFieldChange(_ sender: AnyObject) {
    let percentFormatter = NumberFormatter()
    percentFormatter.numberStyle = .percent
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    
    if let billAmount = Double(billField.text!) {
      let tip   = billAmount * Double(percentFormatter.number(from: tipAmount.titleForSegment(at: tipAmount.selectedSegmentIndex)!)!)
      let total = billAmount + tip
      
      tipLabel.text              = formatter.string(from: NSNumber(value: tip))
      totalLabel.text            = formatter.string(from: NSNumber(value: total))
      twoPersonSplitLabel.text   = formatter.string(from: NSNumber(value: total / 2))
      threePersonSplitLabel.text = formatter.string(from: NSNumber(value: total / 3))
      fourPersonSplitLabel.text  = formatter.string(from: NSNumber(value: total / 4))
      fivePersonSplitLabel.text  = formatter.string(from: NSNumber(value: total / 5))
      
      animateTipView(up: true)
    }
    else {
      if billField.text == "." {
        animateTipView(up: true)
      }
      else {
        animateTipView(up: false)
      }
      
      tipLabel.text = "$0.00"
      totalLabel.text = "$0.00"
    }
    
    if billField.text!.contains(".") {
      billField.keyboardType = .numberPad
    }
    else {
      billField.keyboardType = .decimalPad
    }
    billField.reloadInputViews()
  }
  
}

