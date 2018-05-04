//
//  SplitTreeViewController.swift
//  SplitTree
//
//  Created by Pieter Stragier on 27/04/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit

class SplitTreeViewController: UIViewController, UITextFieldDelegate {

    // MARK: - variables
    var treeSelection: Int?
    var finished: Bool = false
    var numberArray: Array<Int> = [0]
    var solvedNumbers: Array<Int> = []
    var score: Int = 0
    var timer = Timer()
    var seconds: Int = 0
    var honderdsten: Double = 0
    var localdata = UserDefaults.standard
    let treeArray: Array<Int> = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    let redApplesList: Array<Any> = [#imageLiteral(resourceName: "RedApples1"), #imageLiteral(resourceName: "RedApples2"), #imageLiteral(resourceName: "RedApples3"), #imageLiteral(resourceName: "RedApples4"), #imageLiteral(resourceName: "RedApples5")]
    let greenApplesList: Array<Any> = [#imageLiteral(resourceName: "GreenApples1"), #imageLiteral(resourceName: "GreenApples2"), #imageLiteral(resourceName: "GreenApples3"), #imageLiteral(resourceName: "GreenApples4"), #imageLiteral(resourceName: "GreenApples5")]
    var redNumber: Int = 0
    var greenNumber: Int = 0
    
    // MARK: - outlets
    @IBOutlet var myLabels: [UILabel]!
    @IBOutlet var myTextFields: [UITextField]!
    @IBOutlet var myButtons: [UIButton]!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var treeLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var left1: UILabel!
    @IBOutlet weak var left2: UITextField!
    @IBOutlet weak var left3: UILabel!
    @IBOutlet weak var left4: UITextField!
    @IBOutlet weak var left5: UILabel!
    @IBOutlet weak var right1: UITextField!
    @IBOutlet weak var right2: UILabel!
    @IBOutlet weak var right3: UITextField!
    @IBOutlet weak var right4: UILabel!
    @IBOutlet weak var right5: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var TimeStaticLabel: UILabel!
    @IBOutlet weak var newRecordLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var imageApplesLeft: UIImageView!
    @IBOutlet weak var imageApplesRight: UIImageView!
    
    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        self.treeSelection = treeSelection! + 1
        setupLayout()
        for textField in myTextFields {
            textField.text = ""
            textField.backgroundColor = UIColor.white
            textField.isEnabled = true
        }
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let shuffledTreeArray = shuffleArray(array: treeArray)
        self.treeSelection = shuffledTreeArray[0]
        setupLayout()
        for textField in myTextFields {
            textField.text = ""
            textField.backgroundColor = UIColor.white
            textField.isEnabled = true
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        checkTime()
        checkAnswers()
        for textField in myTextFields {
            textField.isEnabled = false
        }
        doneButton.isHidden = true
        continueButton.isHidden = false
        randomButton.isHidden = false
        if self.treeSelection != 20 {
            nextButton.isHidden = false
        } else {
            nextButton.isHidden = true
        }
        // store solved numbers for practiced tree in localdata
        storeData(tree: self.treeSelection!, solved: self.solvedNumbers)
        self.solvedNumbers = []
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        setupLayout()
        for textField in myTextFields {
            textField.text = ""
            textField.backgroundColor = UIColor.white
            textField.isEnabled = true
        }
    }
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let orientationvalue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationvalue, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
        if self.treeSelection! == 1 {
            let shuffledRandom = shuffleArray(array: self.treeArray)
            self.treeSelection = shuffledRandom[0]
        }
        self.right1.delegate = self
        self.left2.delegate = self
        self.right3.delegate = self
        self.left4.delegate = self
        self.right5.delegate = self
        setupLayout()
    }

    override func viewWillLayoutSubviews() {
        // show images of apples
        if self.treeSelection! <= 5 {
            if right1.isFirstResponder {
                redNumber = Int(left1.text!)! - 1
                greenNumber = Int(treeSelection! - Int(left1.text!)! - 1)
            } else if right3.isFirstResponder {
                redNumber = Int(left3.text!)! - 1
                greenNumber = Int(treeSelection! - Int(left3.text!)! - 1)
            } else if right5.isFirstResponder {
                redNumber = Int(left5.text!)! - 1
                greenNumber = Int(treeSelection! - Int(left5.text!)! - 1)
            } else if left2.isFirstResponder {
                greenNumber = Int(right2.text!)! - 1
                redNumber = Int(treeSelection! - Int(right2.text!)! - 1)
            } else if left4.isFirstResponder {
                greenNumber = Int(right4.text!)! - 1
                redNumber = Int(treeSelection! - Int(right4.text!)! - 1)
            }
            if redNumber >= 0 {
                //let leftImage: UIImage = UIImage(named: redApplesList[redNumber] as! String)!
                imageApplesLeft.isHidden = false
                imageApplesLeft.image = redApplesList[redNumber] as? UIImage
            } else {
                imageApplesLeft.isHidden = true
            }
            if greenNumber >= 0 {
                //let rightImage: UIImage = UIImage(named: greenApplesList[greenNumber] as! String)!
                imageApplesRight.isHidden = false
                imageApplesRight.image = greenApplesList[greenNumber] as? UIImage
            } else {
                imageApplesRight.isHidden = true
            }
        } else {
            imageApplesLeft.isHidden = true
            imageApplesRight.isHidden = true
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.timer.invalidate()
    }

    // MARK: - functions
    // MARK: setup layout
    func setupLayout() {
        self.numberArray = [0]
        for button in myButtons {
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 10
        }
        for textField in myTextFields {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.cornerRadius = 5
            textField.isEnabled = true
            textField.isUserInteractionEnabled = true
        }
        randomButton.isHidden = true
        nextButton.isHidden = true
        TimeStaticLabel.isHidden = true
        timeLabel.isHidden = true
        newRecordLabel.isHidden = true
        treeLabel.text = String(describing: treeSelection!)
        continueButton.isHidden = true
        doneButton.isHidden = false
        for label in myLabels {
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.cornerRadius = 5
        }
        
        prepareNumbers()
        right1.becomeFirstResponder()
        if self.treeSelection! == 2 || self.treeSelection! == 3 {
            left4.isHidden = true
            right4.isHidden = true
            left5.isHidden = true
            right5.isHidden = true
        } else {
            left1.isHidden = false
            right1.isHidden = false
            left2.isHidden = false
            right2.isHidden = false
            left3.isHidden = false
            right3.isHidden = false
            left4.isHidden = false
            right4.isHidden = false
            left5.isHidden = false
            right5.isHidden = false
        }
        DispatchQueue.main.async {
            self.runTimer()
        }
        
    }
    
    // MARK: prepare numbers
    func prepareNumbers() {
        // fill number array
        for x in 1...self.treeSelection! {
            numberArray.append(x)
        }
        // shuffle number array
        let shuffledArray = shuffleArray(array: numberArray)
        
        // fill labels with numbers
        if treeSelection! == 2 || treeSelection! == 3 {
            left1.text = String(describing: shuffledArray[0])
            right2.text = String(describing: shuffledArray[1])
            left3.text = String(describing: shuffledArray[2])
        } else {
            left1.text = String(describing: shuffledArray[0])
            right2.text = String(describing: shuffledArray[1])
            left3.text = String(describing: shuffledArray[2])
            right4.text = String(describing: shuffledArray[3])
            left5.text = String(describing: shuffledArray[4])
        }
    }

    // MARK: shuffle Array
    func shuffleArray(array: Array<Int>) -> Array<Int> {
        var tempShuffled: Array<Int> = []
        var tempArray = array
        while 0 < tempArray.count {
            let rand = Int(arc4random_uniform(UInt32(tempArray.count)))
            tempShuffled.append(tempArray[rand])
            tempArray.remove(at: rand)
        }
        return tempShuffled
    }
    
    
    // MARK: check answers
    func checkAnswers() {
        let antwoord1 = right1.text?.trimmingCharacters(in: .whitespaces)
        let antwoord2 = left2.text?.trimmingCharacters(in: .whitespaces)
        let antwoord3 = right3.text?.trimmingCharacters(in: .whitespaces)
        if treeSelection! == 2 || treeSelection! == 3 {
            if antwoord1! != "" {
                if Int(left1.text!)! + Int(antwoord1!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left1.text!)!)
                    right1.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    right1.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                right1.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
            if antwoord2! != "" {
                if Int(antwoord2!)! + Int(right2.text!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(right2.text!)!)
                    left2.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    left2.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                left2.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
            if antwoord3! != "" {
                if Int(left3.text!)! + Int(antwoord3!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left3.text!)!)
                    right3.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    right3.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                right3.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
        } else if treeSelection! >= 4 {
            let antwoord3 = right3.text?.trimmingCharacters(in: .whitespaces)
            let antwoord4 = left4.text?.trimmingCharacters(in: .whitespaces)
            let antwoord5 = right5.text?.trimmingCharacters(in: .whitespaces)
            if antwoord1! != "" {
                if Int(left1.text!)! + Int(antwoord1!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left1.text!)!)
                    right1.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    right1.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                right1.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
            if antwoord2! != "" {
                if Int(antwoord2!)! + Int(right2.text!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(right2.text!)!)
                    left2.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    left2.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                left2.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
            if antwoord3! != "" {
                if Int(left3.text!)! + Int(antwoord3!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left3.text!)!)
                    right3.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    right3.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                right3.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
            if antwoord4! != "" {
                if Int(antwoord4!)! + Int(right4.text!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(right4.text!)!)
                    left4.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    left4.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                left4.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
            if antwoord5! != "" {
                if Int(left5.text!)! + Int(antwoord5!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left5.text!)!)
                    right5.backgroundColor = UIColor.FlatColor.Green.Fern
                } else {
                    right5.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                }
            } else {
                right5.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            }
        }
    }
    
    // MARK: - Textfield Delegate
    // MARK: textfield becomes active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    // MARK: keyboard return function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        // go to next inputfield
        switch textField {
        case right1:
            left2.becomeFirstResponder()
        case left2:
            right3.becomeFirstResponder()
        case right3:
            left4.becomeFirstResponder()
        case left4:
            right5.becomeFirstResponder()
        default:
            right5.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: allowed characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
 
    // MARK: - Timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1/100, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    func updateTimer() {
        honderdsten += 1     
    }

    func checkTime() {
        timer.invalidate()
        TimeStaticLabel.isHidden = false
        timeLabel.isHidden = false
        timeLabel.text = "\((honderdsten).rounded() / 100) sec"
        storeTime(tree: treeSelection!, newTime: Float(honderdsten))
        self.honderdsten = 0.0
    }
    
    // MARK: - Store time to userDefaults
    func storeTime(tree: Int, newTime: Float) {
        var timeKeeper: Dictionary<String, Any> = [:]
        var exTime: Float = 10000.00
        
        // Check if Userdefaults exist
        if localdata.object(forKey: "timeKeeper") != nil {
            timeKeeper = localdata.dictionary(forKey: "timeKeeper")!
            if let existTime = timeKeeper[String(tree)] as? Float {
                exTime = existTime
            }
        } else {
            timeKeeper = [:] as Dictionary<String, Any>
        }
        if newTime < exTime {
            timeKeeper[String(tree)] = newTime
            self.newRecordLabel.isHidden = false
        }
        localdata.set(timeKeeper, forKey: "timeKeeper")
    }
    
    // MARK: - Store data to userDefaults
    func storeData(tree: Int, solved: Array<Int>) {
        var solvedDict: Dictionary<String, Any> = [:]
        var newArray: Array<Int> = []
        
        // Check if Userdefaults exist
        if localdata.object(forKey: "solvedNumbers") != nil {
            solvedDict = localdata.dictionary(forKey: "solvedNumbers")!
            if var exArray = solvedDict[String(tree)] as? Array<Int> {
                for n in solved {
                    if !exArray.contains(n) {
                        exArray.append(n)
                    }
                }
                newArray = exArray
            } else {
                newArray = solved
            }
        } else {
            solvedDict = [:] as Dictionary<String, Any>
            for n in solved {
                newArray.append(n)
            }
            
        }
        solvedDict[String(tree)] = newArray
        localdata.set(solvedDict, forKey: "solvedNumbers")
    }
}
