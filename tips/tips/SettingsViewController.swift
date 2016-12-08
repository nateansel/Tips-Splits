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
  @IBOutlet weak var stepperViewRightConstraint:   NSLayoutConstraint!
  @IBOutlet weak var stepperViewWidthConstraint:   NSLayoutConstraint!
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
  let sharedDefaults     = UserDefaults()
  var showingStepperView = false
  let formatter          = NumberFormatter()
  
  
  
  // MARK: - Methods
  
  // MARK: Override methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.numberStyle = .percent
    settingsView.layer.cornerRadius = 10
    settingsView.layer.masksToBounds = true
    defaultTipSegmentedControl.selectedSegmentIndex  = sharedDefaults.integer(forKey: "defaultTipIndex")
    colorSchemeSegmentedControl.selectedSegmentIndex = sharedDefaults.integer(forKey: "colorSchemeIndex")
    colorSchemeChanged(self)
    
    if sharedDefaults.double(forKey: "leftStepperValue") != 0 {
      leftStepper.value = sharedDefaults.double(forKey: "leftStepperValue") * 100
    } else {
      sharedDefaults.set(0.18, forKey: "leftStepperValue")
      leftStepper.value = 18
    }
    defaultTipSegmentedControl.setTitle(formatter.string(from: NSNumber(value: leftStepper.value / 100)), forSegmentAt: 0)
    
    
    if sharedDefaults.double(forKey: "centerStepperValue") != 0 {
      centerStepper.value = sharedDefaults.double(forKey: "centerStepperValue") * 100
    } else {
      sharedDefaults.set(0.20, forKey: "centerStepperValue")
      centerStepper.value = 20
    }
    defaultTipSegmentedControl.setTitle(formatter.string(from: NSNumber(value: centerStepper.value / 100)), forSegmentAt: 1)
    
    
    if sharedDefaults.double(forKey: "rightStepperValue") != 0 {
      rightStepper.value = sharedDefaults.double(forKey: "rightStepperValue") * 100
    } else {
      sharedDefaults.set(0.25, forKey: "rightStepperValue")
      rightStepper.value = 25
    }
    defaultTipSegmentedControl.setTitle(formatter.string(from: NSNumber(value: rightStepper.value / 100)), forSegmentAt: 2)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let rootView = UIApplication.shared.delegate!.window!!.rootViewController as! ViewController? {
      keyboardHeight = rootView.keyboardHeight
    }
    settingsViewHeightConstraint.constant = view.frame.size.height
    settingsViewTopConstraint.constant    = settingsViewHeightConstraint.constant
    stepperViewTopConstraint.constant     = keyboardHeight
    
    blurEverythingView.effect = nil
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.25,
      animations: { [unowned self] in
        self.blurEverythingView.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.settingsViewTopConstraint.constant = self.view.frame.size.height - self.keyboardHeight
        self.view.layoutIfNeeded()
    })
    
    stepperViewWidthConstraint.constant = defaultTipSegmentedControl.frame.size.width
    if Double((leftStepper.frame.size.width * 3) + 12) > Double(stepperViewWidthConstraint.constant) {
      let newWidth = CGFloat((leftStepper.frame.size.width * 3) + 12)
      stepperViewWidthConstraint.constant = newWidth
      let newRight = CGFloat((view.frame.size.width - stepperViewWidthConstraint.constant) / 2)
      stepperViewRightConstraint.constant = newRight
    }
    
    leftStepperLeftConstraint.constant   = CGFloat((stepperViewWidthConstraint.constant / 6)       - (leftStepper.frame.size.width / 2))
    centerStepperLeftConstraint.constant = CGFloat((stepperViewWidthConstraint.constant / 2)       - (centerStepper.frame.size.width / 2))
    rightStepperLeftConstraint.constant  = CGFloat(((stepperViewWidthConstraint.constant / 6) * 5) - (rightStepper.frame.size.width / 2))
  }
  
  // MARK: Color scheme
  
  ///  Calls the correct method to update the color scheme to the new color
  ///  scheme. Fires a notification to alert the root view to update its colors
  ///  as well.
  ///
  /// - parameter sender: Any object that calls this method. Cannot be nil.
  ///
  @IBAction func colorSchemeChanged(_ sender: AnyObject) {
    sharedDefaults.set(colorSchemeSegmentedControl.selectedSegmentIndex, forKey: "colorSchemeIndex")
    sharedDefaults.synchronize()
    switch colorSchemeSegmentedControl.selectedSegmentIndex {
      case 0:
        changeToBlueScheme()
      case 1:
        changeToOrangeScheme()
      default:
        print("color scheme not changed")
    }
    NotificationCenter.default.post(name: Notification.Name(rawValue: "colorSchemeChanged"), object: nil)
  }
  
  ///  Animates the change to the blue color scheme.
  ///
  func changeToBlueScheme() {
    let blueColor = UIColor(red:0.23, green:0.45, blue:0.74, alpha:1)
    UIView.animate(withDuration: 0.25, animations: { [unowned self] in
      self.colorSchemeSegmentedControl.tintColor = blueColor
      self.defaultTipSegmentedControl.tintColor  = blueColor
      self.editButton.tintColor                  = blueColor
      self.leftStepper.tintColor                 = blueColor
      self.centerStepper.tintColor               = blueColor
      self.rightStepper.tintColor                = blueColor
      self.editButton.setImage(UIImage(named: "editButtonImageBlue"), for: UIControlState())
    })
  }
  
  ///  Animates the change to the orange color scheme.
  ///
  func changeToOrangeScheme() {
    let orangeColor = UIColor(red:1, green:0.47, blue:0.2, alpha:1)
    UIView.animate(withDuration: 0.25, animations: { [unowned self] in
      self.colorSchemeSegmentedControl.tintColor = orangeColor
      self.defaultTipSegmentedControl.tintColor  = orangeColor
      self.editButton.tintColor                  = orangeColor
      self.leftStepper.tintColor                 = orangeColor
      self.centerStepper.tintColor               = orangeColor
      self.rightStepper.tintColor                = orangeColor
      self.editButton.setImage(UIImage(named: "editButtonImageOrange"), for: UIControlState())
      self.settingsView.layoutIfNeeded()
    })
  }
  
  // MARK: View animations
  
  ///  Animates the settings view going up or down to show or hide the tip
  ///  amount editing UI elements underneath.
  ///
  @IBAction func animateSettingsViewEditMode(_ sender: AnyObject) {
    if !showingStepperView {
      UIView.animate(withDuration: 0.25,
        delay: 0,
        options: UIViewAnimationOptions(),
        animations: { [unowned self] in
          self.editButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
          self.settingsViewTopConstraint.constant = self.view.frame.height - (self.keyboardHeight + self.stepperView.frame.height)
          self.view.layoutIfNeeded()
        }, completion: nil)
      showingStepperView = true
    }
    else {
      UIView.animate(withDuration: 0.25,
        delay: 0,
        options: UIViewAnimationOptions(),
        animations: { [unowned self] in
          self.editButton.transform = CGAffineTransform(rotationAngle: 0)
          self.settingsViewTopConstraint.constant = self.view.frame.height - self.keyboardHeight
          self.view.layoutIfNeeded()
        }, completion: nil)
      showingStepperView = false
    }
  }
  
  ///  Animates the dismiss of the settings view controller. Called when any of
  ///  the blur view is tapped.
  ///
  /// - parameter sender: Any object that calls this method. Cannot be nil.
  ///
  @IBAction func dismissViewController(_ sender: AnyObject) {
    sharedDefaults.synchronize()
    UIView.animate(withDuration: 0.25,
      animations: { [unowned self] in
        self.blurEverythingView.effect = nil
        self.settingsViewTopConstraint.constant = self.view.frame.height
        self.view.layoutIfNeeded()
      }, completion: { [unowned self] (finished: Bool) in
        self.dismiss(animated: true, completion: {
          if let rootView = UIApplication.shared.delegate!.window!!.rootViewController as! ViewController? {
            rootView.billField.becomeFirstResponder()
          }
        })
    })
  }
  
  // MARK: Value changes
  
  ///  Called when the left tip segmented control is edited. Updates the value
  ///  stored in NSUserDefaults.
  ///
  @IBAction func leftTipChanged(_ sender: AnyObject) {
    defaultTipSegmentedControl.setTitle(formatter.string(from: NSNumber(value: leftStepper.value / 100)), forSegmentAt: 0)
    sharedDefaults.set(leftStepper.value / 100, forKey: "leftStepperValue")
    sharedDefaults.set(true, forKey: "refreshTipValues")
  }
  
  ///  Called when the center tip segmented control is edited. Updates the value
  ///  stored in NSUserDefaults.
  ///
  @IBAction func centerTipChanged(_ sender: AnyObject) {
    defaultTipSegmentedControl.setTitle(formatter.string(from: NSNumber(value: centerStepper.value / 100)), forSegmentAt: 1)
    sharedDefaults.set(centerStepper.value / 100, forKey: "centerStepperValue")
    sharedDefaults.set(true, forKey: "refreshTipValues")
  }
  
  ///  Called when the right tip segmented control is edited. Updates the value
  ///  stored in NSUserDefaults.
  ///
  @IBAction func rightTipChanged(_ sender: AnyObject) {
    defaultTipSegmentedControl.setTitle(formatter.string(from: NSNumber(value: rightStepper.value / 100)), forSegmentAt: 2)
    sharedDefaults.set(rightStepper.value / 100, forKey: "rightStepperValue")
    sharedDefaults.set(true, forKey: "refreshTipValues")
  }
  
  ///  Called when the default tip segmented control is edited. Updates the value
  ///  stored in NSUserDefaults.
  ///
  @IBAction func defaultTipChanged(_ sender: AnyObject) {
    sharedDefaults.set(defaultTipSegmentedControl.selectedSegmentIndex, forKey: "defaultTipIndex")
    sharedDefaults.set(true, forKey: "refreshDefaultTip")
    sharedDefaults.synchronize()
  }
}
