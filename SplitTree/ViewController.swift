//
//  ViewController.swift
//  SplitTree
//
//  Created by Pieter Stragier on 27/04/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    // MARK: - Variables
    let localdata = UserDefaults.standard
    var iapProducts = [SKProduct]()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var parentalGate = UIView()
    var parentalCheck: Bool = false
    let answerField = UITextField()
    let startColor: CGColor = UIColor.FlatColor.Green.Fern.cgColor
    let doneColor: CGColor = UIColor.FlatColor.Yellow.Turbo.cgColor
    var rekenBladMessageView = UIView()
    var countSolved: Int = 0
    var solvedTreeArray: Array<Int> = []
    var allTreesArray: Array<Int> = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    
    @IBOutlet weak var restorePurchaseButton: UIButton!
    @IBOutlet var myButtons: [UIButton]!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button14: UIButton!
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button16: UIButton!
    @IBOutlet weak var button17: UIButton!
    @IBOutlet weak var button18: UIButton!
    @IBOutlet weak var button19: UIButton!
    @IBOutlet weak var button20: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet var lockedButtons: [UIButton]!
    @IBOutlet weak var rekenbladButton: UIButton!
    
    @IBAction func resetTapped(_ sender: UIButton) {
        let controller = UIAlertController(title: NSLocalizedString("All progress will be lost!", comment: ""), message: NSLocalizedString("Are you sure you want to reset all trees?", comment: ""), preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { alertAction in self.resetAll() }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { alertAction in
        }
        controller.addAction(ok)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func restorePurchaseTapped(_ sender: UIButton) {
        restorePurchaseButton.setTitleColor(.red, for: .highlighted)
        activityIndicatorShow(NSLocalizedString("restoring purchase...", comment: ""))
        restorePurchaseButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.enableButton), userInfo: nil, repeats: false)
        SplitTreeFull.store.restorePurchases()
        self.setupLayout()
        self.viewWillLayoutSubviews()
    }
    
    @IBAction func unlockTapped(_ sender: UIButton) {
        unlockButton.setTitleColor(.red, for: .highlighted)
        activityIndicatorShow(NSLocalizedString("contacting AppStore...", comment: ""))
        unlockButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.enableButton), userInfo: nil, repeats: false)
        setupParentalGateView(option: "buy")
        //parentalGate window will continue to passParentalControlAndBuy
        parentalGate.isHidden = false
        self.setupLayout()
        self.viewWillLayoutSubviews()
    }
    
    func passParentalControlAndBuy() {
        if ConnectionCheck.isConnectedToNetwork() {
            if parentalCheck == true {
                //            print("parental gate passed")
                if IAPHelper.canMakePayments() {
                    //                print("Can make payments")
                    SplitTreeFull.store.buyProduct(iapProducts[0])
                    self.setupLayout()
                    self.viewWillLayoutSubviews()
                } else {
                    // MARK: in-app-purchase fail message
                    let failController = UIAlertController(title: NSLocalizedString("In-app purchases not enabled", comment: ""), message: NSLocalizedString("Please enable in-app purchase in settings", comment: ""), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { alertAction in
                    }
                    let settings = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { alertAction in
                        failController.dismiss(animated: true, completion: nil)
                        let url: URL? = URL(string: UIApplicationOpenSettingsURLString)
                        //let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                        if url != nil {
                            if UIApplication.shared.canOpenURL(url!) {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url!)
                                }
                            }
                        }
                    })
                    failController.addAction(ok)
                    failController.addAction(settings)
                    present(failController, animated: true, completion: nil)
                }
                parentalCheck = false
            }
            self.setupLayout()
            self.viewWillLayoutSubviews()
        } else {
            self.answerField.resignFirstResponder()
            let alertcontroller = UIAlertController(title: NSLocalizedString("You need a working internet connection", comment: ""), message: NSLocalizedString("Check your connection settings and try again.", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertcontroller.addAction(ok)
            present(alertcontroller, animated: true, completion: nil)
            self.effectView.removeFromSuperview()
        }
    }

    @IBAction func rekenbladButtonTapped(_ sender: UIButton) {
        // check if all trees up to ten have been solved
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let orientationvalue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationvalue, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
        // Do any additional setup after loading the view, typically from a nib.
        SplitTreeFull.store.requestProducts{success, products in
            if success {
                self.iapProducts = products!
                self.viewWillLayoutSubviews()
            }
        }
        // Setup layout
        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for button in myButtons {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for button in myButtons {
            button.layer.borderWidth = 2
        }
        if unlockButton.isHidden == true {
            restorePurchaseButton.isHidden = false
        } else {
            restorePurchaseButton.isHidden = true
        }
        if twoAndThree() {
            rekenbladButton.isEnabled = true
        } else {
            rekenbladButton.isEnabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Functions
    // MARK: Setup layout
    func setupLayout() {
        if !SplitTreeFull.store.isProductPurchased(SplitTreeFull.FullVersion) {
            unlockButton.isHidden = true
            for lockedButton in lockedButtons {
                lockedButton.isEnabled = true
                lockedButton.setBackgroundImage(nil, for: .normal)
            }
        } else {
            unlockButton.isHidden = false
            for lockedButton in lockedButtons {
                lockedButton.isEnabled = false
                lockedButton.setBackgroundImage(#imageLiteral(resourceName: "Black_Lock").withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 0, 0)), for: .normal)
            }            
        }
        resetButton.layer.borderWidth = 2
        resetButton.layer.cornerRadius = 10
        unlockButton.layer.borderWidth = 2
        unlockButton.layer.cornerRadius = 10
        rekenbladButton.layer.borderWidth = 2
        rekenbladButton.layer.cornerRadius = 10
        for button in myButtons {
            button.layer.borderWidth = 2
            button.titleLabel?.minimumScaleFactor = 0.1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.contentMode = .scaleToFill
        }
        checkProgress()
        if twoAndThree() {
            rekenbladButton.isEnabled = true
            rekenbladButton.backgroundColor = UIColor.init(white: 1, alpha: 1)
        } else {
            rekenbladButton.isEnabled = false
            rekenbladButton.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        }
    }
    
    // MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            
        case "Segue1":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 1
        case "Segue2":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 2
        case "Segue3":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 3
        case "Segue4":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 4
        case "Segue5":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 5
        case "Segue6":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 6
        case "Segue7":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 7
        case "Segue8":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 8
        case "Segue9":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 9
        case "Segue10":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 10
        case "Segue11":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 11
        case "Segue12":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 12
        case "Segue13":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 13
        case "Segue14":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 14
        case "Segue15":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 15
        case "Segue16":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 16
        case "Segue17":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 17
        case "Segue18":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 18
        case "Segue19":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 19
        case "Segue20":
            let destination = segue.destination as! SplitTreeViewController
            destination.treeSelection = 20
        case "segueToRekenblad":
            let destination = segue.destination as! RekenBladViewController
            let countSolve = calculateCountSolved()
            let solveTreeArray = calculateSolvedTree()
            destination.numberArray = solveTreeArray
            destination.countSolved = countSolve
        default:
            break
        }
    }

    // MARK: - Unwind
    @IBAction func unwindToOverview(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? SplitTreeViewController {
            if sourceViewController.score >= 0 {
                // check if all numbers have been solved for a tree
                checkProgress()
            }
        }
    }

    // MARK: - Reset data
    // MARK: reset all
    func resetAll() {
        resetData()
        resetTimes()
        resetScores()
        setupLayout()
        viewWillLayoutSubviews()
    }
    
    // MARK: reset data
    func resetData() {
        var solvedDict: Dictionary<String, Any> = [:]
        var newArray: Array<Int> = []
        let trees: Array<Int> = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        for tree in trees {
            if localdata.object(forKey: "solvedNumbers") != nil {
                solvedDict = localdata.dictionary(forKey: "solvedNumbers")!
                if (solvedDict[String(tree)] as? Array<Int>) != nil {
                    newArray = []
                } else {
                    newArray = []
                }
            } else {
            newArray = []
            }
            solvedDict[String(tree)] = newArray
            localdata.set(solvedDict, forKey: "solvedNumbers")
        }
    }
    
    // MARK: reset times
    func resetTimes() {
        var newTime: Float = 10000.0
        var timeKeeper: Dictionary<String, Any> = [:]
        let trees: Array<Int> = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        for tree in trees {
            if localdata.object(forKey: "timeKeeper") != nil {
                timeKeeper = localdata.dictionary(forKey: "timeKeeper")!
                if (timeKeeper[String(tree)] as? Float) != nil {
                    newTime = 10000.0
                } else {
                    newTime = 10000.0
                }
            } else {
                newTime = 10000.0
            }
            timeKeeper[String(tree)] = newTime
            localdata.set(timeKeeper, forKey: "timeKeeper")
        }
    }
    
    // MARK: reset scores
    func resetScores() {
        if localdata.object(forKey: "correctAnswers") != nil {
            localdata.set(0, forKey: "correctAnswers")
        }
        if localdata.object(forKey: "totalAnswers") != nil {
            localdata.set(0, forKey: "totalAnswers")
        }
    }
    
    // MARK: - ceck progress
    func checkProgress() {
        for button in myButtons {
            let tree = Int(myButtons.index(of: button)!) + 1
            // Load data
            let storedDict = localdata.dictionary(forKey: "solvedNumbers")
            if let solvedForTree = storedDict?[String(tree)] {
                let solvedArray = solvedForTree as? Array<Int>
                if (solvedArray?.count)! - 1 >= tree {
                    // completely solved
                    button.layer.backgroundColor = doneColor
                    button.layer.borderColor = startColor
                } else if (solvedArray?.count)! >= 1 {
                    // partly solved
                    button.layer.borderColor = doneColor
                    button.layer.backgroundColor = startColor
                } else {
                    // Nothing solved
                    button.layer.borderColor = UIColor.black.cgColor
                    button.layer.backgroundColor = startColor
                }
            } else {
                // Nothing ever solved
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.backgroundColor = startColor
            }
        }
    }
    // MARK: - Activity Indicator
    func activityIndicatorShow(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 220, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.5, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 220, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        self.view.addSubview(effectView)
    }

    @objc func enableButton() {
        self.unlockButton.isEnabled = true
        self.restorePurchaseButton.isEnabled = true
    }
    
    // MARK: - setup parental gate window
    func setupParentalGateView(option: String) {
        //        print("setup AppVersionView")
        self.parentalGate.isHidden = true
        self.parentalGate.translatesAutoresizingMaskIntoConstraints = false
        let width: CGFloat = self.view.frame.width
        let height: CGFloat = self.view.frame.height
        self.parentalGate=UIView(frame:CGRect(x: (self.view.center.x)-(width/3), y: (self.view.center.y)-(height/3), width: width / 1.5, height: height / 2.5))
        
        parentalGate.backgroundColor = UIColor.orange
        parentalGate.layer.cornerRadius = 8
        parentalGate.layer.borderWidth = 1
        parentalGate.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(parentalGate)
        self.parentalGate.isHidden = true
        
        let viewTitle = UILabel()
        viewTitle.text = NSLocalizedString("Parental control", comment: "")
        viewTitle.font = UIFont.boldSystemFont(ofSize: 14)
        viewTitle.textColor = UIColor.white
        viewTitle.textAlignment = .center
        viewTitle.adjustsFontSizeToFitWidth = true
        viewTitle.minimumScaleFactor = 0.2
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let parGateText = UILabel()
        if option == "buy" {
            parGateText.text = NSLocalizedString("Grown ups only!", comment: "") + "\n" + NSLocalizedString("Answer correct to buy the full version", comment: "")
        } else {
            parGateText.text = NSLocalizedString("Grown ups only!", comment: "") + "\n" + NSLocalizedString("Answer correct to continue", comment: "")
        }
        parGateText.font = UIFont.boldSystemFont(ofSize: 16)
        parGateText.textColor = UIColor.white
        parGateText.textAlignment = .center
        parGateText.adjustsFontSizeToFitWidth = true
        parGateText.minimumScaleFactor = 0.2
        parGateText.translatesAutoresizingMaskIntoConstraints = false
        
        let parGateQuestion = UILabel()
        parGateQuestion.text = NSLocalizedString("How much is SEVENTEEN + SEVEN - THIRTEEN? (in words)", comment: "")
        parGateQuestion.font = UIFont.systemFont(ofSize: 20)
        parGateQuestion.textColor = UIColor.white
        parGateQuestion.numberOfLines = 3
        parGateQuestion.textAlignment = .center
        parGateQuestion.adjustsFontSizeToFitWidth = true
        parGateQuestion.minimumScaleFactor = 0.2
        parGateQuestion.translatesAutoresizingMaskIntoConstraints = false
        
        
        answerField.font = UIFont.systemFont(ofSize: 20)
        answerField.keyboardType = .alphabet
        answerField.tintColor = UIColor.black
        answerField.backgroundColor = UIColor.white
        answerField.textColor = UIColor.black
        answerField.textAlignment = .center
        answerField.adjustsFontSizeToFitWidth = true
        answerField.layer.cornerRadius = 8
        answerField.layer.borderWidth = 2
        answerField.layer.borderColor = UIColor.black.cgColor
        answerField.becomeFirstResponder()
        answerField.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Cancel button!
        let buttonCancel = UIButton()
        buttonCancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        buttonCancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonCancel.setTitleColor(.blue, for: .normal)
        buttonCancel.setTitleColor(.red, for: .highlighted)
        buttonCancel.backgroundColor = .white
        buttonCancel.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonCancel.titleLabel?.minimumScaleFactor = 0.2
        buttonCancel.layer.cornerRadius = 8
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.gray.cgColor
        buttonCancel.showsTouchWhenHighlighted = true
        buttonCancel.translatesAutoresizingMaskIntoConstraints = false
        buttonCancel.addTarget(self, action: #selector(answerCancel), for: .touchUpInside)
        
        // MARK: OK button!
        let buttonOK = UIButton()
        buttonOK.setTitle("OK", for: .normal)
        buttonOK.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonOK.setTitleColor(.blue, for: .normal)
        buttonOK.setTitleColor(.red, for: .highlighted)
        buttonOK.backgroundColor = .white
        buttonOK.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonOK.titleLabel?.minimumScaleFactor = 0.2
        buttonOK.layer.cornerRadius = 8
        buttonOK.layer.borderWidth = 1
        buttonOK.layer.borderColor = UIColor.gray.cgColor
        buttonOK.showsTouchWhenHighlighted = true
        buttonOK.translatesAutoresizingMaskIntoConstraints = false
        buttonOK.addTarget(self, action: #selector(answeredOK), for: .touchUpInside)
        
        // MARK: Vertical
        
        let vertStack = UIStackView(arrangedSubviews: [parGateText, parGateQuestion, answerField, buttonCancel, buttonOK])
        
        vertStack.axis = .vertical
        vertStack.distribution = .fillProportionally
        vertStack.alignment = .fill
        vertStack.spacing = 8
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        self.parentalGate.addSubview(vertStack)
        
        //Stackview Layout (constraints)
        vertStack.leftAnchor.constraint(equalTo: parentalGate.leftAnchor, constant: 20).isActive = true
        vertStack.topAnchor.constraint(equalTo: parentalGate.topAnchor, constant: 15).isActive = true
        vertStack.rightAnchor.constraint(equalTo: parentalGate.rightAnchor, constant: -20).isActive = true
        vertStack.heightAnchor.constraint(equalTo: parentalGate.heightAnchor, constant: -20).isActive = true
        vertStack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        vertStack.isLayoutMarginsRelativeArrangement = true
    }
    
    
    @objc func answeredOK() {
        //        print("Answer: \(answerField.text!)")
        let parAnswer = answerField.text?.trimmingCharacters(in: .whitespaces)
        if parAnswer == "Eleven" || parAnswer == "eleven" || parAnswer == "ELEVEN" {
            parentalCheck = true
            passParentalControlAndBuy()
        } else {
            answerField.resignFirstResponder()
            self.effectView.removeFromSuperview()
            parentalCheck = false
            let wrongAnswerAlert = UIAlertController(title: NSLocalizedString("Wrong answer", comment: ""), message: NSLocalizedString("The answer you provided was not correct, try again.", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            wrongAnswerAlert.addAction(ok)
            present(wrongAnswerAlert, animated: true, completion: nil)
        }
        answerField.text = ""
        answerField.resignFirstResponder()
        parentalGate.isHidden = true
    }
    
    @objc func answerCancel() {
        self.effectView.removeFromSuperview()
        parentalGate.isHidden = true
        parentalCheck = false
        answerField.text = ""
        answerField.resignFirstResponder()
    }

    func calculateCountSolved() -> Int {
        self.countSolved = 0
        // check if all trees up to ten have been solved
        let storedDict = localdata.dictionary(forKey: "solvedNumbers")
        let tenArray: Array<Int> = [2, 3, 4, 5, 6, 7, 8, 9, 10]
        for number in tenArray {
            if let solvedForTree = storedDict?[String(number)] {
                let solvedArray = solvedForTree as? Array<Int>
                if (solvedArray?.count)! - 1 >= number {
                    // completely solved
                    self.countSolved += 1
                }
            }
        }
        
        return self.countSolved
    }
    
    func calculateSolvedTree() -> Array<Int> {
        let storedDict = localdata.dictionary(forKey: "solvedNumbers")
        for number in allTreesArray {
            if let solvedForTree = storedDict?[String(number)] {
                let solvedArray = solvedForTree as? Array<Int>
                if (solvedArray?.count)! - 1 >= number {
                    // completely solved
                    self.solvedTreeArray.append(number)
                }
            }
        }
        return self.solvedTreeArray
    }
    func twoAndThree() -> Bool {
        // If 2 and 3 solved : true
        var countTwoThree: Int = 0
        let storedDict = localdata.dictionary(forKey: "solvedNumbers")
        let twoThreeArray: Array<Int> = [2, 3]
        
        for number in twoThreeArray {
            if let solvedForTree = storedDict?[String(number)] {
                let solvedArray = solvedForTree as? Array<Int>
                if (solvedArray?.count)! - 1 >= number {
                    countTwoThree += 1
                }
            }
        }
        if countTwoThree == 2 {
            return true
        }
        return false
    }
}

