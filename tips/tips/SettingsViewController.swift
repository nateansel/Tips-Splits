//
//  SettingsViewController.swift
//  tips
//
//  Created by Nathan Ansel on 12/4/15.
//  Copyright © 2015 Nathan Ansel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Views
  @IBOutlet weak var stepperView:  UIView!
  @IBOutlet weak var settingsView: UIView!
  
  // MARK: Constraints
  @IBOutlet weak var settingsViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var settingsViewTopConstraint:    NSLayoutConstraint!
  @IBOutlet weak var blurEverythingView:           UIVisualEffectView!
  @IBOutlet weak var stepperViewTopConstraint:     NSLayoutConstraint!
  @IBOutlet weak var leftStepperLeftConstraint:    NSLayoutConstraint!
  @IBOutlet weak var centerStepperLeftConstraint:  NSLayoutConstraint!
  @IBOutlet weak var rightStepperLeftConstraint:   NSLayoutConstraint!
  
  // MARK: Input controls
  @IBOutlet weak var colorSchemeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var defaultTipSegmentedControl:  UISegmentedControl!
  @IBOutlet weak var editButton:                  UIButton!
  @IBOutlet weak var leftStepper:                 UIStepper!
  @IBOutlet weak var centerStepper:               UIStepper!
  @IBOutlet weak var rightStepper:                UIStepper!
  
  // MARK: Miscellanious variables
  var keyboardHeight     = CGFloat()
  let sharedDefaults     = NSUserDefaults()
  var showingStepperView = false
  let formatter          = NSNumberFormatter()
  
  
  
  // MARK: - Methods
  // MARK: Override methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.numberStyle = .PercentStyle
    settingsView.layer.cornerRadius = 5
    settingsView.layer.masksToBounds = true
    defaultTipSegmentedControl.selectedSegmentIndex  = sharedDefaults.integerForKey("defaultTipIndex")
    colorSchemeSegmentedControl.selectedSegmentIndex = sharedDefaults.integerForKey("colorSchemeIndex")
    colorSchemeChanged(self)
    
    if sharedDefaults.doubleForKey("leftStepperValue") != 0 {
      leftStepper.value = sharedDefaults.doubleForKey("leftStepperValue") * 100
    }
    else {
      sharedDefaults.setDouble(0.18, forKey: "leftStepperValue")
      leftStepper.value = 18
    }
    leftTipChanged(self)
    
    
    if sharedDefaults.doubleForKey("centerStepperValue") != 0 {
      centerStepper.value = sharedDefaults.doubleForKey("centerStepperValue") * 100
    }
    else {
      sharedDefaults.setDouble(0.20, forKey: "centerStepperValue")
      centerStepper.value = 20
    }
    centerTipChanged(self)
    
    
    if sharedDefaults.doubleForKey("rightStepperValue") != 0 {
      rightStepper.value = sharedDefaults.doubleForKey("rightStepperValue") * 100
    }
    else {
      sharedDefaults.setDouble(0.25, forKey: "rightStepperValue")
      rightStepper.value = 25
    }
    rightTipChanged(self)
  }
  
  
  
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let rootView = UIApplication.sharedApplication().delegate!.window!!.rootViewController as! ViewController? {
      self.keyboardHeight = rootView.keyboardHeight
    }
    settingsViewHeightConstraint.constant = view.frame.size.height
    settingsViewTopConstraint.constant    = settingsViewHeightConstraint.constant
    stepperViewTopConstraint.constant     = keyboardHeight
    
    blurEverythingView.effect = nil
  }
  
  
  
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animateWithDuration(0.25,
      animations: {
        self.blurEverythingView.effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        self.settingsViewTopConstraint.constant = self.view.frame.size.height - self.keyboardHeight
        self.view.layoutIfNeeded()
    })
    
    leftStepperLeftConstraint.constant    = CGFloat((stepperView.frame.size.width / 6)       - (leftStepper.frame.size.width / 2))
    centerStepperLeftConstraint.constant  = CGFloat((stepperView.frame.size.width / 2)       - (centerStepper.frame.size.width / 2))
    rightStepperLeftConstraint.constant   = CGFloat(((stepperView.frame.size.width / 6) * 5) - (rightStepper.frame.size.width / 2))
  }
  
  
  
  
  // MARK: Color scheme
  @IBAction func colorSchemeChanged(sender: AnyObject) {
    sharedDefaults.setInteger(colorSchemeSegmentedControl.selectedSegmentIndex, forKey: "colorSchemeIndex")
    sharedDefaults.synchronize()
    switch colorSchemeSegmentedControl.selectedSegmentIndex {
      case 0:
        changeToBlueScheme()
      case 1:
        changeToOrangeScheme()
      default:
        print("color scheme not changed")
    }
    NSNotificationCenter.defaultCenter().postNotificationName("colorSchemeChanged", object: nil)
  }
  
  
  
  
  
  func changeToBlueScheme() {
    let blueColor = UIColor(red:0.23, green:0.45, blue:0.74, alpha:1)
    UIView.animateWithDuration(0.25, animations: {
      self.colorSchemeSegmentedControl.tintColor = blueColor
      self.defaultTipSegmentedControl.tintColor  = blueColor
      self.editButton.tintColor                  = blueColor
      self.leftStepper.tintColor                 = blueColor
      self.centerStepper.tintColor               = blueColor
      self.rightStepper.tintColor                = blueColor
      self.editButton.setImage(UIImage(named: "editButtonImageBlue"), forState: .Normal)
    })
  }
  
  
  
  
  
  func changeToOrangeScheme() {
    let orangeColor = UIColor(red:1, green:0.47, blue:0.2, alpha:1)
    UIView.animateWithDuration(0.25, animations: {
      self.colorSchemeSegmentedControl.tintColor = orangeColor
      self.defaultTipSegmentedControl.tintColor  = orangeColor
      self.editButton.tintColor                  = orangeColor
      self.leftStepper.tintColor                 = orangeColor
      self.centerStepper.tintColor               = orangeColor
      self.rightStepper.tintColor                = orangeColor
      self.editButton.setImage(UIImage(named: "editButtonImageOrange"), forState: .Normal)
      self.settingsView.layoutIfNeeded()
    })
  }
  
  
  
  
  // MARK: View animations
  @IBAction func animateSettingsViewEditMode(sender: AnyObject) {
    if !showingStepperView {
      UIView.animateWithDuration(0.25,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: {
          self.editButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
          self.settingsViewTopConstraint.constant = self.view.frame.size.height - (self.keyboardHeight + self.stepperView.frame.size.height)
          self.view.layoutIfNeeded()
        }, completion: nil)
      showingStepperView = true
    }
    else {
      UIView.animateWithDuration(0.25,
        delay: 0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: {
          self.editButton.transform = CGAffineTransformMakeRotation(CGFloat(0))
          self.settingsViewTopConstraint.constant = self.view.frame.size.height - self.keyboardHeight
          self.view.layoutIfNeeded()
        }, completion: nil)
      showingStepperView = false
    }
  }
  
  
  
  
  
  @IBAction func dismissViewController(sender: AnyObject) {
    sharedDefaults.synchronize()
    UIView.animateWithDuration(0.25,
      animations: {
        self.blurEverythingView.effect = nil
        self.settingsViewTopConstraint.constant = self.view.frame.size.height
        self.view.layoutIfNeeded()
      }, completion: { (finished: Bool) in
        self.dismissViewControllerAnimated(true, completion: {
          if let rootView = UIApplication.sharedApplication().delegate!.window!!.rootViewController as! ViewController? {
            rootView.billField.becomeFirstResponder()
          }
        })
    })
  }
  
  
  
  // MARK: Value changes
  
  
  @IBAction func leftTipChanged(sender: AnyObject) {
    defaultTipSegmentedControl.setTitle(formatter.stringFromNumber(leftStepper.value / 100), forSegmentAtIndex: 0)
    sharedDefaults.setDouble(leftStepper.value / 100, forKey: "leftStepperValue")
  }
  
  
  
  @IBAction func centerTipChanged(sender: AnyObject) {
    defaultTipSegmentedControl.setTitle(formatter.stringFromNumber(centerStepper.value / 100), forSegmentAtIndex: 1)
    sharedDefaults.setDouble(centerStepper.value / 100, forKey: "centerStepperValue")
  }
  
  
  
  
  @IBAction func rightTipChanged(sender: AnyObject) {
    defaultTipSegmentedControl.setTitle(formatter.stringFromNumber(rightStepper.value / 100), forSegmentAtIndex: 2)
    sharedDefaults.setDouble(rightStepper.value / 100, forKey: "rightStepperValue")
  }
  
  
  
  @IBAction func defaultTipChanged(sender: AnyObject) {
    sharedDefaults.setInteger(defaultTipSegmentedControl.selectedSegmentIndex, forKey: "defaultTipIndex")
    sharedDefaults.setBool(true, forKey: "refreshDefaultTip")
    sharedDefaults.synchronize()
  }
}
