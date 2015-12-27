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
  let sharedDefaults    = NSUserDefaults()
  var keyboardHeight    = CGFloat()
  var animationDuration = NSNumber()
  var animationOptions  = UIViewAnimationOptions.CurveEaseIn
  
  
  
  
  // MARK: - Methods
  // MARK: Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeColorScheme:", name: "colorSchemeChanged", object: nil)

    currencyLabel.text = NSNumberFormatter().currencySymbol
    
    tipLabel.text = "$0.00"
    totalLabel.text = "$0.00"
    
    tipAmount.selectedSegmentIndex = sharedDefaults.integerForKey("defaultTipIndex")
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    NSNotificationCenter.defaultCenter().postNotificationName("colorSchemeChanged", object: nil)
    
    billField.font             = UIFont.monospacedDigitSystemFontOfSize(billField.font!.pointSize,             weight: UIFontWeightThin)
    tipLabel.font              = UIFont.monospacedDigitSystemFontOfSize(tipLabel.font!.pointSize,              weight: UIFontWeightThin)
    totalLabel.font            = UIFont.monospacedDigitSystemFontOfSize(totalLabel.font!.pointSize,            weight: UIFontWeightThin)
    twoPersonSplitLabel.font   = UIFont.monospacedDigitSystemFontOfSize(twoPersonSplitLabel.font!.pointSize,   weight: UIFontWeightThin)
    threePersonSplitLabel.font = UIFont.monospacedDigitSystemFontOfSize(threePersonSplitLabel.font!.pointSize, weight: UIFontWeightThin)
    fourPersonSplitLabel.font  = UIFont.monospacedDigitSystemFontOfSize(fourPersonSplitLabel.font!.pointSize,  weight: UIFontWeightThin)
    fivePersonSplitLabel.font  = UIFont.monospacedDigitSystemFontOfSize(fivePersonSplitLabel.font!.pointSize,  weight: UIFontWeightThin)
  }
  
  
  
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    billField.text = ""
    tipViewConstraint.constant = view.frame.size.height
    textFieldChange(self)
  }
  
  
  
  
  
  override func viewDidAppear(animated: Bool) {
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
  func keyboardWillShow(notification: NSNotification) {
    let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    keyboardHeight = keyboardFrame.height
    tipViewHeight.constant = view.frame.size.height - (keyboardHeight + 8 + billField.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height)
    scrollViewHeight.constant = tipViewHeight.constant - 46
    if sharedDefaults.boolForKey("refreshDefaultTip") {
      tipAmount.selectedSegmentIndex = sharedDefaults.integerForKey("defaultTipIndex")
      sharedDefaults.setBool(false, forKey: "refreshDefaultTip")
    }
    changeTipAmountTitles()
  }
  
  
  
  
  
  ///
  ///  Animates the change of the color scheme. Uses the colorIndex (a value set
  ///  in the settings) to determine which color scheme to animate to.
  ///
  /// - author: Nathan Ansel
  /// - parameter notification: An NSNotification activated when the color
  ///                            scheme needs to be changed.
  ///
  func changeColorScheme(notification: NSNotification) {
    let colorIndex = sharedDefaults.integerForKey("colorSchemeIndex")
    switch colorIndex {
      case 0:
        let blueColor      = UIColor(red:0.23, green:0.45, blue:0.74, alpha:1)
        let lightBlueColor = UIColor(red:0.49, green:0.75, blue:1, alpha:1)
        UIView.animateWithDuration(0.25,
          animations: {
            self.tipView.backgroundColor               = blueColor
            self.SettingsContainerView.backgroundColor = lightBlueColor
        })
      case 1:
        let orangeColor      = UIColor(red:1, green:0.47, blue:0.2, alpha:1)
        let lightOrangeColor = UIColor(red:1, green:0.56, blue:0.43, alpha:1)
        UIView.animateWithDuration(0.25,
          animations: {
            self.tipView.backgroundColor               = orangeColor
            self.SettingsContainerView.backgroundColor = lightOrangeColor
        })
      default:
        print("ERROR: Color Scheme not changed")
    }
  }
  
  
  
  
  // MARK: Animations
  
  ///
  ///  Animates the tipView sliding up onto the screen, or down off the screen.
  ///
  /// - author: Nathan Ansel
  /// - parameter up: A boolean value determining if the tipView needs to
  ///                  animate up or down
  ///
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
  
  
  
  
  ///
  ///  Changes the tip amount titles to match the values held in NSUserDefaults
  ///
  /// - author: Nathan Ansel
  ///
  func changeTipAmountTitles() {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    
    if sharedDefaults.boolForKey("refreshTipValues") {
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
      sharedDefaults.setBool(false, forKey: "refreshTipValues")
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
  @IBAction func textFieldChange(sender: AnyObject) {
    let percentFormatter = NSNumberFormatter()
    percentFormatter.numberStyle = .PercentStyle
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    
    if let billAmount = Double(billField.text!) {
      let tip   = billAmount * Double(percentFormatter.numberFromString(tipAmount.titleForSegmentAtIndex(tipAmount.selectedSegmentIndex)!)!)
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
  
}

