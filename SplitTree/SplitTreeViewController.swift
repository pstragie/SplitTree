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
    var redNumber: Int = 0
    var greenNumber: Int = 0
    let treeImageList2: Array<Any> = [#imageLiteral(resourceName: "palmtwins0+2"), #imageLiteral(resourceName: "palmtwins1+1"), #imageLiteral(resourceName: "palmtwins2+0")]
    let treeImageList3: Array<Any> = [#imageLiteral(resourceName: "palmtwins0+3"), #imageLiteral(resourceName: "palmtwins1+2"), #imageLiteral(resourceName: "palmtwins2+1"), #imageLiteral(resourceName: "palmtwins3+0")]
    let treeImageList4: Array<Any> = [#imageLiteral(resourceName: "palmtwins0+4"), #imageLiteral(resourceName: "palmtwins1+3"), #imageLiteral(resourceName: "palmtwins2+2"), #imageLiteral(resourceName: "palmtwins3+1"), #imageLiteral(resourceName: "palmtwins4+0")]
    
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
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var subviewBottom: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        self.treeSelection = treeSelection! + 1
        setupLayout()
        for textField in myTextFields {
            textField.text = ""
            textField.backgroundColor = UIColor.white
            textField.isEnabled = true
            textField.viewWithTag(1)?.becomeFirstResponder()
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
            textField.viewWithTag(1)?.becomeFirstResponder()
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        checkAnswers() // + Store data
        checkTime()
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
        self.solvedNumbers = []
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        setupLayout()
        for textField in myTextFields {
            textField.text = ""
            textField.backgroundColor = UIColor.white
            textField.isEnabled = true
            textField.viewWithTag(1)?.becomeFirstResponder()
        }
    }
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("viewDidLoad")
        
        let orientationvalue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationvalue, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
        if self.treeSelection! == 1 {
            let shuffledRandom = shuffleArray(array: self.treeArray)
            self.treeSelection = shuffledRandom[0]
        }
        
        for mytextField in myTextFields {
            mytextField.delegate = self
        }
        setupLayout()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print("viewWillLayoutSubviews")
        // show images of coconuts
        if self.treeSelection! <= 3 {
            if right1.isFirstResponder {
                redNumber = Int(left1.text!)!
            } else if right3.isFirstResponder {
                redNumber = Int(left3.text!)!
            } else if left2.isFirstResponder {
                redNumber = Int(treeSelection! - Int(right2.text!)!)
            }
            if treeSelection! == 2 {
                bgImage.image = treeImageList2[redNumber] as? UIImage
            } else if treeSelection! == 3 {
                bgImage.image = treeImageList3[redNumber] as? UIImage
            }
        } else if self.treeSelection! == 4 {
            if right1.isFirstResponder {
                redNumber = Int(left1.text!)!
            } else if right3.isFirstResponder {
                redNumber = Int(left3.text!)!
            } else if left2.isFirstResponder {
                redNumber = Int(treeSelection! - Int(right2.text!)!)
            } else if right5.isFirstResponder {
                redNumber = Int(left5.text!)!
            } else if left4.isFirstResponder {
                redNumber = Int(treeSelection! - Int(right4.text!)!)
            }
            if treeSelection! == 4 {
                bgImage.image = treeImageList4[redNumber] as? UIImage
            }
        } else {
            bgImage.image = #imageLiteral(resourceName: "palmtwins0+0")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.timer.invalidate()
    }

    // MARK: - functions
    // MARK: setup layout
    func setupLayout() {
//        print("setupLayout")
        self.subView.translatesAutoresizingMaskIntoConstraints = false
        self.score = 0
        self.numberArray = [0]
        for button in myButtons {
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 10
        }
        for textfield in myTextFields {
            textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            //textfield.addTarget(self, action: #selector(uiMenuViewControllerDidShowMenu(_:)), for: .allTouchEvents)
            textfield.layer.borderColor = UIColor.black.cgColor
            textfield.layer.borderWidth = 1
            textfield.layer.cornerRadius = 5
            textfield.textColor = UIColor.FlatColor.Violet.BlueGem
            textfield.layer.masksToBounds = true
            textfield.backgroundColor = UIColor.white
            textfield.isEnabled = true
            //textfield.adjustsFontSizeToFitWidth = true
            //textfield.minimumFontSize = 1.0
            //textfield.allowsEditingTextAttributes = false
        }
        if SplitTreeFull.store.isProductPurchased(SplitTreeFull.FullVersion) {
            randomButton.isUserInteractionEnabled = true
            nextButton.isUserInteractionEnabled = true
        } else {
            randomButton.isUserInteractionEnabled = false
            nextButton.isUserInteractionEnabled = false
            randomButton.setImage(#imageLiteral(resourceName: "Black_Lock_NoEdge"), for: .normal)
            randomButton.imageView?.contentMode = .scaleAspectFit
            nextButton.setImage(#imageLiteral(resourceName: "Black_Lock_NoEdge"), for: .normal)
            nextButton.imageView?.contentMode = .scaleAspectFit
        }
        randomButton.isHidden = true
        randomButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextButton.isHidden = true
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
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
            label.layer.masksToBounds = true
        }
        treeLabel.layer.borderWidth = 1
        treeLabel.layer.borderColor = UIColor.black.cgColor
        treeLabel.layer.cornerRadius = 5
        treeLabel.layer.masksToBounds = true
        prepareNumbers()
        
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
        self.right1.becomeFirstResponder()
    }
    
    @objc func uiMenuViewControllerDidShowMenu(_ textfield: UITextField) {
        // textFieldShouldReturn not responding appropriate when using this!!!
//        print("uiMenuViewControllerDidShowMenu")
        let menuController = UIMenuController.shared
        menuController.setMenuVisible(false, animated: false)
        menuController.update()
        textfield.becomeFirstResponder()
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
        storeData(tree: self.treeSelection!, solved: self.solvedNumbers)
    }
    
    // MARK: - Textfield Delegate
    // MARK: textfield becomes active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldBeginEditing")
        textField.isUserInteractionEnabled = true
        textField.isEnabled = true
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
//        print("textFieldDidChange")
        if self.treeSelection! >= 4 {
            switch textField {
            case right1:
                if Int(textField.text!) == Int(treeSelection!) - Int(left1.text!)! {
                    checkNextResponder(textField)
                }
            case left2:
                if Int(textField.text!) == Int(treeSelection!) - Int(right2.text!)! {
                    checkNextResponder(textField)
                }
            case right3:
                if Int(textField.text!) == Int(treeSelection!) - Int(left3.text!)! {
                    checkNextResponder(textField)
                }
            case left4:
                if Int(textField.text!) == Int(treeSelection!) - Int(right4.text!)! {
                    checkNextResponder(textField)
                }
            default:
                if Int(textField.text!) == Int(treeSelection!) - Int(left5.text!)! {
                    checkNextResponder(textField)
                }
            }
        } else {
            switch textField {
            case right1:
                if Int(textField.text!) == Int(treeSelection!) - Int(left1.text!)! {
                    checkNextResponder(textField)
                }
            case left2:
                if Int(textField.text!) == Int(treeSelection!) - Int(right2.text!)! {
                    checkNextResponder(textField)
                }
            default:
                if Int(textField.text!) == Int(treeSelection!) - Int(left3.text!)! {
                    checkNextResponder(textField)
                }
            }
        }
        
    }
    
    func checkNextResponder(_ textField: UITextField) {
//        print("checkNextResponder")
        if self.treeSelection! >= 4 {
            switch textField {
            case right1:
                if left2.text! == "" || Int(left2.text!)! != Int(treeSelection!) - Int(right2.text!)! {
                    left2.selectAll(self)
                    left2.becomeFirstResponder()
                } else {
                    if right3.text! == "" || Int(right3.text!)! != Int(treeSelection!) - Int(left3.text!)! {
                        right3.selectAll(self)
                        right3.becomeFirstResponder()
                    } else {
                        if left4.text! == "" || Int(left4.text!)! != Int(treeSelection!) - Int(right4.text!)! {
                            left4.selectAll(self)
                            left4.becomeFirstResponder()
                        } else {
                            if right5.text! == "" || Int(right5.text!)! != Int(treeSelection!) - Int(left5.text!)! {
                                right5.selectAll(self)
                                right5.becomeFirstResponder()
                            } else {
                                textField.resignFirstResponder()
                                self.doneButtonTapped(doneButton)
                            }
                        }
                    }
                }
            case left2:
                if right3.text! == "" || Int(right3.text!)! != Int(treeSelection!) - Int(left3.text!)! {
                    right3.selectAll(self)
                    right3.becomeFirstResponder()
                } else {
                    if left4.text! == "" || Int(left4.text!)! != Int(treeSelection!) - Int(right4.text!)! {
                        left4.selectAll(self)
                        left4.becomeFirstResponder()
                    } else {
                        if right5.text! == "" || Int(right5.text!)! != Int(treeSelection!) - Int(left5.text!)! {
                            right5.selectAll(self)
                            right5.becomeFirstResponder()
                        } else {
                            textField.resignFirstResponder()
                            self.doneButtonTapped(doneButton)
                        }
                    }
                }
            case right3:
                if left4.text! == "" || Int(left4.text!)! != Int(treeSelection!) - Int(right4.text!)! {
                    left4.selectAll(self)
                    left4.becomeFirstResponder()
                } else {
                    if right5.text! == "" || Int(right5.text!)! != Int(treeSelection!) - Int(left5.text!)! {
                        right5.selectAll(self)
                        right5.becomeFirstResponder()
                    } else {
                        textField.resignFirstResponder()
                        self.doneButtonTapped(doneButton)
                    }
                }
            case left4:
                if right5.text! == "" || Int(right5.text!)! != Int(treeSelection!) - Int(left5.text!)! {
                    right5.selectAll(self)
                    right5.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                    self.doneButtonTapped(doneButton)
                }
            default:
                if right1.text! == "" || Int(right1.text!)! != Int(treeSelection!) - Int(left1.text!)! {
                    right1.selectAll(self)
                    right1.becomeFirstResponder()
                } else {
                    if left2.text! == "" || Int(left2.text!)! != Int(treeSelection!) - Int(right2.text!)! {
                        left2.selectAll(self)
                        left2.becomeFirstResponder()
                    } else {
                        if right3.text! == "" || Int(right3.text!)! != Int(treeSelection!) - Int(left3.text!)! {
                            right3.selectAll(self)
                            right3.becomeFirstResponder()
                        } else {
                            if left4.text! == "" || Int(left4.text!)! != Int(treeSelection!) - Int(right4.text!)! {
                                left4.selectAll(self)
                                left4.becomeFirstResponder()
                            } else {
                                if right5.text! == "" || Int(right5.text!)! != Int(treeSelection!) - Int(left5.text!)! {
                                    right5.selectAll(self)
                                    right5.becomeFirstResponder()
                                } else {
                                    textField.resignFirstResponder()
                                    self.doneButtonTapped(doneButton)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            switch textField {
            case right1:
                if left2.text! == "" || Int(left2.text!)! != Int(treeSelection!) - Int(right2.text!)! {
                    left2.selectAll(self)
                    left2.becomeFirstResponder()
                } else {
                    if right3.text! == "" || Int(right3.text!)! != Int(treeSelection!) - Int(left3.text!)! {
                        right3.selectAll(self)
                        right3.becomeFirstResponder()
                    } else {
                        textField.resignFirstResponder()
                        self.doneButtonTapped(doneButton)
                }
            }
            case left2:
                if right3.text! == "" || Int(right3.text!)! != Int(treeSelection!) - Int(left3.text!)! {
                    right3.selectAll(self)
                    right3.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                    self.doneButtonTapped(doneButton)
            }
            default:
                if right1.text! == "" || Int(right1.text!)! != Int(treeSelection!) - Int(left1.text!)! {
                    right1.selectAll(self)
                    right1.becomeFirstResponder()
                } else {
                    if left2.text! == "" || Int(left2.text!)! != Int(treeSelection!) - Int(right2.text!)! {
                        left2.selectAll(self)
                        left2.becomeFirstResponder()
                    } else {
                        if right3.text! == "" || Int(right3.text!)! != Int(treeSelection!) - Int(left3.text!)! {
                            right3.selectAll(self)
                            right3.becomeFirstResponder()
                        } else {
                            textField.resignFirstResponder()
                            self.doneButtonTapped(doneButton)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: keyboard return function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // go to next inputfield
//        print("textFieldShouldReturn")
        if self.treeSelection! >= 4 {
            let nextTag = nextEmptyFieldTag(currentTag: textField.tag)
//            print("nextTag = \(nextTag)")
            if nextTag == 0 {
                textField.resignFirstResponder()
            } else {
                for tf in myTextFields {
                    tf.viewWithTag(nextTag)?.becomeFirstResponder()
                }
            }
        } else {
            switch textField {
            case right1:
                self.left2.becomeFirstResponder()
            case left2:
                self.right3.becomeFirstResponder()
            default:
                self.right3.resignFirstResponder()
                doneButtonTapped(doneButton)
            }
        }
        return true
    }
    
    // MARK: nextEmptyFieldTag
    func nextEmptyFieldTag(currentTag: Int) -> Int {
        var ctag: Int = 0
        if currentTag == myTextFields.count {
            ctag = 0
        } else {
            ctag = currentTag
        }
        for tf in myTextFields.sorted(by: {$0.tag < $1.tag})[ctag...myTextFields.count - 1] {
            if tf.text == "" {
                return tf.tag
            }
        }
        return 0
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
        timer = Timer.scheduledTimer(timeInterval: 1/100, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func updateTimer() {
        honderdsten += 1
        if honderdsten > 100000.0 {
            self.invalidateTimer()
        }
    }

    func checkTime() {
        timer.invalidate()
        if treeSelection! == 2 || treeSelection! == 3 {
            if score == 3 {
                showTime()
            }
        } else {
            if score == 5 {
                showTime()
            }
        }
        // reset timer
        self.honderdsten = 0.0
    }
    
    func showTime() {
        TimeStaticLabel.isHidden = false
        timeLabel.isHidden = false
        timeLabel.text = "\((honderdsten).rounded() / 100) s"
        storeTime(tree: treeSelection!, newTime: Float(honderdsten))
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
    
    func invalidateTimer() {
        self.timer.invalidate()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.subviewBottom.constant = keyboardSize.height + 4
            self.subView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    }
}
