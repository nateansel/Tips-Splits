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
  
  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipAmount: UISegmentedControl!
  @IBOutlet weak var tipViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var tipViewHeight: NSLayoutConstraint!
  @IBOutlet weak var tipPercentBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var settingsButtonBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
  @IBOutlet weak var tipView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  let sharedDefaults: NSUserDefaults = NSUserDefaults()
  var keyboardHeight: CGFloat = CGFloat()
  var animationDuration: NSNumber = NSNumber()
  var animationOptions: UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseIn
  
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var twoPersonSplitLabel: UILabel!
  @IBOutlet weak var threePersonSplitLabel: UILabel!
  @IBOutlet weak var fourPersonSplitLabel: UILabel!
  @IBOutlet weak var fivePersonSplitLabel: UILabel!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeColorScheme:", name: "colorSchemeChanged", object: nil)

    currencyLabel.text = NSNumberFormatter().currencySymbol
    
    tipLabel.text = "$0.00"
    totalLabel.text = "$0.00"
    billField.text = ""
    
    tipAmount.selectedSegmentIndex = sharedDefaults.integerForKey("defaultTipIndex")
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    NSNotificationCenter.defaultCenter().postNotificationName("colorSchemeChanged", object: nil)
  }
  
  
  
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  
  
  
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    billField.becomeFirstResponder()
  }
  
  
  
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    print("viewWillDisappear")
  }
  
  
  
  
  func keyboardWillShow(notification: NSNotification) {
    let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    keyboardHeight = keyboardFrame.height
    tipViewHeight.constant = view.frame.size.height - (keyboardHeight + 8 + billField.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height)
    scrollViewHeight.constant = tipViewHeight.constant - 46
    if sharedDefaults.boolForKey("refreshDefaultTip") {
      tipAmount.selectedSegmentIndex = sharedDefaults.integerForKey("defaultTipIndex")
      sharedDefaults.setBool(false, forKey: "refreshDefaultTip")
    }
    textFieldChange(self)
    changeTipAmountTitles()
  }
  
  
  
  
  func changeTipAmountTitles() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    
    if sharedDefaults.doubleForKey("leftStepperValue") != 0 {
      tipAmount.setTitle(formatter.stringFromNumber(sharedDefaults.doubleForKey("leftStepperValue")), forSegmentAtIndex: 0)
    }
    else {
      sharedDefaults.setDouble(0.18, forKey: "leftStepperValue")
      tipAmount.setTitle("18%", forSegmentAtIndex: 0)
    }
    
    if sharedDefaults.doubleForKey("centerStepperValue") != 0 {
      tipAmount.setTitle(formatter.stringFromNumber(sharedDefaults.doubleForKey("centerStepperValue")), forSegmentAtIndex: 1)
    }
    else {
      sharedDefaults.setDouble(0.20, forKey: "centerStepperValue")
      tipAmount.setTitle("20%", forSegmentAtIndex: 1)
    }
    
    if sharedDefaults.doubleForKey("rightStepperValue") != 0 {
      tipAmount.setTitle(formatter.stringFromNumber(sharedDefaults.doubleForKey("rightStepperValue")), forSegmentAtIndex: 2)
    }
    else {
      sharedDefaults.setDouble(0.25, forKey: "rightStepperValue")
      tipAmount.setTitle("25%", forSegmentAtIndex: 2)
    }
  }
  
  
  
  
  
  
  func changeColorScheme(notification: NSNotification) {
    let colorIndex = sharedDefaults.integerForKey("colorSchemeIndex")
    switch colorIndex {
      case 0:
        let blueColor = UIColor(red:0.23, green:0.45, blue:0.74, alpha:1)
        UIView.animateWithDuration(0.25,
          animations: {
            self.tipView.backgroundColor = blueColor
        })
      case 1:
        let orangeColor = UIColor(red:1, green:0.47, blue:0.2, alpha:1)
        UIView.animateWithDuration(0.25,
          animations: {
            self.tipView.backgroundColor = orangeColor
        })
      default:
        print("Color Scheme not changed")
    }
  }
  
  

  
  
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  
  

  @IBAction func textFieldChange(sender: AnyObject) {
    let percentFormatter = NSNumberFormatter()
    percentFormatter.numberStyle = .PercentStyle
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    
    if let billAmount = Double(billField.text!) {
      let tip = billAmount * Double(percentFormatter.numberFromString(tipAmount.titleForSegmentAtIndex(tipAmount.selectedSegmentIndex)!)!)
      let total = billAmount + tip
      
      tipLabel.text              = formatter.stringFromNumber(tip)
      totalLabel.text            = formatter.stringFromNumber(total)
      twoPersonSplitLabel.text   = formatter.stringFromNumber(total / 2)
      threePersonSplitLabel.text = formatter.stringFromNumber(total / 3)
      fourPersonSplitLabel.text  = formatter.stringFromNumber(total / 4)
      fivePersonSplitLabel.text  = formatter.stringFromNumber(total / 5)
      
      animateTipView(true)
    }
    else {
      if billField.text == "." {
        animateTipView(true)
      }
      else {
        animateTipView(false)
      }
      
      tipLabel.text = "$0.00"
      totalLabel.text = "$0.00"
    }
    
    if billField.text!.containsString(".") {
      billField.keyboardType = .NumberPad
    }
    else {
      billField.keyboardType = .DecimalPad
    }
    billField.reloadInputViews()
  }

  
  
  
  
  func animateTipView(up: Bool) {
    if up {
      if self.tipViewConstraint.constant != 8 {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        UIView.animateWithDuration(0.3,
          animations: {
            self.tipViewConstraint.constant = CGFloat(8)
            self.view.layoutIfNeeded()
        })
      }
    }
    else {
      if self.tipViewConstraint.constant == 8 {
        UIView.animateWithDuration(0.3,
          animations: {
            self.tipViewConstraint.constant = CGFloat(self.view.frame.size.height)
            self.view.layoutIfNeeded()
        })
      }
    }
  }
  
  
  
  
  
  @IBAction func showSettingsView(sender: AnyObject) {
    billField.resignFirstResponder()
    print("billField.resignFirstResponder()")
  }
  
  
  
  
  
  @IBAction func onViewTap(sender: AnyObject) {
    if !billField.editing {
      self.showSettingsView(self)
    }
  }
  
}

