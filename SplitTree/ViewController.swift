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
    
    @IBAction func resetTapped(_ sender: UIButton) {
        let controller = UIAlertController(title: NSLocalizedString("All progress will be lost!", comment: ""), message: NSLocalizedString("Are you sure you want to reset all trees?", comment: ""), preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { alertAction in
            self.resetData()
            self.resetTimes() }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { alertAction in
        }
        controller.addAction(ok)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
        viewWillLayoutSubviews()
    }
    
    @IBAction func restorePurchaseTapped(_ sender: UIButton) {
        restorePurchaseButton.setTitleColor(.red, for: .highlighted)
        activityIndicatorShow(NSLocalizedString("restoring purchase...", comment: ""))
        restorePurchaseButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.enableButton), userInfo: nil, repeats: false)
        SplitTreeFull.store.restorePurchases()
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
    }
    
    func passParentalControlAndBuy() {
        if ConnectionCheck.isConnectedToNetwork() {
            if parentalCheck == true {
                //            print("parental gate passed")
                if IAPHelper.canMakePayments() {
                    //                print("Can make payments")
                    SplitTreeFull.store.buyProduct(iapProducts[0])
                    self.viewWillLayoutSubviews()
                } else {
                    // MARK: in-app-purchase fail message
                    let failController = UIAlertController(title: NSLocalizedString("In-app purchases not enabled", comment: ""), message: NSLocalizedString("Please enable in-app purchase in settings", comment: ""), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { alertAction in
                    }
                    let settings = UIAlertAction(title: "Settings", style: .default, handler: { alertAction in
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

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let orientationvalue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationvalue, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
        // Do any additional setup after loading the view, typically from a nib.
        // Setup layout
        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        for button in myButtons {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        for button in myButtons {
            
            button.layer.borderWidth = 2
            let tree = Int(myButtons.index(of: button)!) + 1
            // Load data
            
            let storedDict = localdata.dictionary(forKey: "solvedNumbers")
            if let solvedForTree = storedDict?[String(tree)] {
                let solvedArray = solvedForTree as? Array<Int>
                print("arraycount: \(String(describing: solvedArray?.count)) en tree: \(tree)")
                if (solvedArray?.count)! - 1 == tree {
                    button.layer.backgroundColor = UIColor.yellow.cgColor
                } else if (solvedArray?.count)! >= 1 {
                    button.layer.borderColor = UIColor.darkGray.cgColor
                }
            } else {
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.backgroundColor = UIColor.green.cgColor
            }
        }
        if unlockButton.isHidden == true {
            restorePurchaseButton.isHidden = false
        } else {
            restorePurchaseButton.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Functions
    // MARK: Setup layout
    func setupLayout() {
        if SplitTreeFull.store.isProductPurchased(SplitTreeFull.FullVersion) {
            unlockButton.isHidden = true
        } else {
            unlockButton.isHidden = false
        }
        resetButton.layer.borderWidth = 2
        resetButton.layer.cornerRadius = 10
        unlockButton.layer.borderWidth = 2
        unlockButton.layer.cornerRadius = 10
        for button in myButtons {
            
            button.layer.borderWidth = 2
            let tree = Int(myButtons.index(of: button)!) + 1
            // Load data
            
            let storedDict = localdata.dictionary(forKey: "solvedNumbers")
            if let solvedForTree = storedDict?[String(tree)] {
                let solvedArray = solvedForTree as? Array<Int>
                print("arraycount: \(String(describing: solvedArray?.count)) en tree: \(tree)")
                if (solvedArray?.count)! - 1 == tree {
                    button.layer.backgroundColor = UIColor.yellow.cgColor
                } else if (solvedArray?.count)! >= 1 {
                    button.layer.borderColor = UIColor.darkGray.cgColor
                } 
            }
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
        default:
            break
        }
    }

    // MARK: - Unwind
    @IBAction func unwindToOverview(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? SplitTreeViewController {
            if sourceViewController.score >= 0 {
                // store solved numbers for practiced tree in localdata
                storeData(tree: sourceViewController.treeSelection!, solved: sourceViewController.solvedNumbers)
                print("solved Numbers: \(sourceViewController.solvedNumbers)")
                // check if all numbers have been solved for a tree
                let storedDict = localdata.dictionary(forKey: "solvedNumbers")
                if let solvedForTree = storedDict?[String(sourceViewController.treeSelection!)] {
                    let solvedArray = solvedForTree as? Array<Int>
                    print("solvedArray in localdata: \(String(describing: solvedArray!))")
                    if solvedArray?.count == (sourceViewController.treeSelection! + 1) {
                        myButtons[sourceViewController.treeSelection! - 1].layer.borderColor = UIColor.green.cgColor
                    } else {
                        myButtons[sourceViewController.treeSelection! - 1].layer.borderColor = UIColor.yellow.cgColor
                    }
                } else {
                    myButtons[sourceViewController.treeSelection! - 1].layer.borderColor = UIColor.yellow.cgColor
                }
            }
        }
    }

    // MARK: - Store data to userDefaults
    func storeData(tree: Int, solved: Array<Int>) {
        var solvedDict: Dictionary<String, Any> = [:]
        var newArray: Array<Int> = []
        
        // Check if Userdefaults exist
        if localdata.object(forKey: "solvedNumbers") != nil {
            print("solved numbers exist in localdata")
            solvedDict = localdata.dictionary(forKey: "solvedNumbers")!
            if var exArray = solvedDict[String(tree)] as? Array<Int> {
                for n in solved {
                    if !exArray.contains(n) {
                        exArray.append(n)
                    }
                }
                print("exArray: \(exArray)")
                newArray = exArray
            } else {
                newArray = solved
            }
        } else {
            print("solved numbers does not exist in localdata")
            solvedDict = [:] as Dictionary<String, Any>
            for n in solved {
                newArray.append(n)
            }
            
        }
        print("newArray: \(newArray)")
        solvedDict[String(tree)] = newArray
        localdata.set(solvedDict, forKey: "solvedNumbers")
    }
    
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
    
    // MARK: - Activity Indicator
    func activityIndicatorShow(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 220, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.5, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 220, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.addSubview(activityIndicator)
        effectView.addSubview(strLabel)
        self.view.addSubview(effectView)
    }

    func enableButton() {
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
        buttonCancel.setTitle("Cancel", for: .normal)
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
    
    
    func answeredOK() {
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
    func answerCancel() {
        self.effectView.removeFromSuperview()
        parentalGate.isHidden = true
        parentalCheck = false
        answerField.text = ""
        answerField.resignFirstResponder()
    }

}

