//
//  SplitTreeViewController.swift
//  SplitTree
//
//  Created by Pieter Stragier on 27/04/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit

class SplitTreeViewController: UIViewController {

    // MARK: - variables
    var treeSelection: Int?
    var finished: Bool = false
    var numberArray: Array<Int> = [0]
    var practicedNumbers: Array<Int> = []
    var solvedNumbers: Array<Int> = []
    var score: Int = 0
    var timer = Timer()
    var seconds: Int = 0
    var honderdsten: Double = 0
    var localdata = UserDefaults.standard
    
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
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        checkTime()
        checkAnswers()
        right1.isEnabled = false
        left2.isEnabled = false
        right3.isEnabled = false
        left4.isEnabled = false
        right5.isEnabled = false
        doneButton.isHidden = true
        continueButton.isHidden = false
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
    }
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let orientationvalue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationvalue, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
        if treeSelection! == 1 {
            var randomList: Array<Int> = []
            for n in 4...20 {
                randomList.append(n)
            }
            let shuffledRandom = shuffleArray(array: randomList)
            self.treeSelection = shuffledRandom[0]
        }
        print("tree Selection = \(self.treeSelection!)")
        setupLayout()
        DispatchQueue.main.async {
            self.runTimer()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - functions
    // MARK: setup layout
    func setupLayout() {
        doneButton.layer.borderWidth = 2
        doneButton.layer.cornerRadius = 10
        continueButton.layer.borderWidth = 2
        continueButton.layer.cornerRadius = 10
        backButton.layer.borderWidth = 2
        backButton.layer.cornerRadius = 10
        TimeStaticLabel.isHidden = true
        timeLabel.isHidden = true
        newRecordLabel.isHidden = true
        treeLabel.text = String(describing: treeSelection!)
        continueButton.isHidden = true
        doneButton.isHidden = false
        prepareNumbers()
        right1.becomeFirstResponder()
        if treeSelection! == 2 {
            left3.isHidden = true
            right3.isHidden = true
            left4.isHidden = true
            right4.isHidden = true
            left5.isHidden = true
            right5.isHidden = true
        } else if treeSelection! == 3 {
            left3.isHidden = false
            right3.isHidden = false
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
    }
    
    // MARK: prepare numbers
    func prepareNumbers() {
        // fill number array
        for x in 1...treeSelection! {
            numberArray.append(x)
        }
        print("number Array = \(numberArray)")
        
        // shuffle number array
        let shuffledArray = shuffleArray(array: numberArray)
        print("shuffled Array = \(shuffledArray)")
        
        // fill labels with numbers
        if treeSelection! == 2 {
            left1.text = String(describing: shuffledArray[0])
            right2.text = String(describing: shuffledArray[1])
            practicedNumbers.append(contentsOf: shuffledArray[0...1])
        } else if treeSelection! == 3 {
            left1.text = String(describing: shuffledArray[0])
            right2.text = String(describing: shuffledArray[1])
            left3.text = String(describing: shuffledArray[2])
            practicedNumbers.append(contentsOf: shuffledArray[0...2])
        } else {
            left1.text = String(describing: shuffledArray[0])
            right2.text = String(describing: shuffledArray[1])
            left3.text = String(describing: shuffledArray[2])
            right4.text = String(describing: shuffledArray[3])
            left5.text = String(describing: shuffledArray[4])
            practicedNumbers.append(contentsOf: shuffledArray[0...4])
        }
        
        
        print("practiced numbers = \(practicedNumbers)")
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
        if treeSelection! == 2 {
            if antwoord1! != "" {
                if Int(left1.text!)! + Int(antwoord1!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left1.text!)!)
                    right1.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    right1.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                right1.layer.backgroundColor = UIColor.red.cgColor
            }
            if antwoord2! != "" {
                if Int(antwoord2!)! + Int(right2.text!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(right2.text!)!)
                    left2.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    left2.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                left2.layer.backgroundColor = UIColor.red.cgColor
            }
        } else if treeSelection! == 3 {
            let antwoord3 = right3.text?.trimmingCharacters(in: .whitespaces)
            if antwoord1! != "" {
                if Int(left1.text!)! + Int(antwoord1!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left1.text!)!)
                    right1.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    right1.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                right1.layer.backgroundColor = UIColor.red.cgColor
            }
            if antwoord2! != "" {
                if Int(antwoord2!)! + Int(right2.text!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(right2.text!)!)
                    left2.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    left2.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                left2.layer.backgroundColor = UIColor.red.cgColor
            }
            if antwoord3! != "" {
                if Int(left3.text!)! + Int(antwoord3!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left3.text!)!)
                    right3.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    right3.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                right3.layer.backgroundColor = UIColor.red.cgColor
            }
        } else if treeSelection! >= 4 {
            let antwoord3 = right3.text?.trimmingCharacters(in: .whitespaces)
            let antwoord4 = left4.text?.trimmingCharacters(in: .whitespaces)
            let antwoord5 = right5.text?.trimmingCharacters(in: .whitespaces)
            if antwoord1! != "" {
                if Int(left1.text!)! + Int(antwoord1!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left1.text!)!)
                    right1.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    right1.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                right1.layer.backgroundColor = UIColor.red.cgColor
            }
            if antwoord2! != "" {
                if Int(antwoord2!)! + Int(right2.text!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(right2.text!)!)
                    left2.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    left2.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                left2.layer.backgroundColor = UIColor.red.cgColor
            }
            if antwoord3! != "" {
                if Int(left3.text!)! + Int(antwoord3!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left3.text!)!)
                    right3.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    right3.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                right3.layer.backgroundColor = UIColor.red.cgColor
            }
            if antwoord4! != "" {
                if Int(antwoord4!)! + Int(right4.text!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(right4.text!)!)
                    left4.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    left4.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                left4.layer.backgroundColor = UIColor.red.cgColor
            }
            if antwoord5! != "" {
                if Int(left5.text!)! + Int(antwoord5!)! == treeSelection! {
                    score += 1
                    solvedNumbers.append(Int(left5.text!)!)
                    right5.layer.backgroundColor = UIColor.green.cgColor
                } else {
                    right5.layer.backgroundColor = UIColor.red.cgColor
                }
            } else {
                right5.layer.backgroundColor = UIColor.red.cgColor
            }
        }
    }
    
    // MARK: - keyboard return function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // go to next inputfield
        if right1.isFirstResponder {
            left2.becomeFirstResponder()
        }
        if left2.isFirstResponder {
            right3.becomeFirstResponder()
        }
        if right3.isFirstResponder {
            left4.becomeFirstResponder()
        }
        if left4.isFirstResponder {
            right5.becomeFirstResponder()
        }
        if right5.isFirstResponder {
            doneButton.becomeFirstResponder()
        }
        if doneButton.isFirstResponder {
            continueButton.becomeFirstResponder()
        }
        return true
    }
    
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
        honderdsten += 1     //This will decrement(count down)the seconds.
    }

    func checkTime() {
        timer.invalidate()
        print("timer: \(honderdsten)")
        TimeStaticLabel.isHidden = false
        timeLabel.isHidden = false
        timeLabel.text = "\((honderdsten).rounded() / 100) sec"
        storeTime(tree: treeSelection!, newTime: Float(honderdsten))
        
    }
    
    // MARK: - Store data to userDefaults
    func storeTime(tree: Int, newTime: Float) {
        var timeKeeper: Dictionary<String, Any> = [:]
        var exTime: Float = 10000.00
        
        // Check if Userdefaults exist
        if localdata.object(forKey: "timeKeeper") != nil {
            timeKeeper = localdata.dictionary(forKey: "timeKeeper")!
            if let existTime = timeKeeper[String(tree)] as? Float {
                print("stored time: \(existTime)")
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
}
