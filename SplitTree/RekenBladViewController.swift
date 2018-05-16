//
//  RekenBladViewController.swift
//  SplitTree
//
//  Created by Pieter Stragier on 12/05/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit

class RekenBladViewController: UIViewController, UITextFieldDelegate {
    
    var numberArray: Array<Int> = []
    var countSolved: Int = 0
    var shuffledSumArray: Array<Int> = []
    var shuffledMinusArray: Array<Int> = []
    let signArray: Array<String> = ["+", "-"]
    var correctAnswers: Int = 0
    var totalAnswers: Int = 0
    var sumsDict: Dictionary<Int,Array<Int>> = [:] // [sum: [number1, number2]
    var minusDict: Dictionary<Int,Array<Int>> = [:] // [sum: [number1, number2]
    let localdata = UserDefaults.standard
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var vertStacks: [UIStackView]!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet var myButtons: [UIButton]!
    @IBOutlet var myLabels: [UILabel]!
    @IBOutlet var myLabelsLeft: [UILabel]!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var buttonStack: UIStackView!
    
    @IBOutlet var myTextFields: [UITextField]!
    @IBOutlet var sumLabels: [UILabel]!
    @IBOutlet var subtractionLabels: [UILabel]!
    @IBOutlet var sumFirstLabels: [UILabel]!
    @IBOutlet var mySumTextFields: [UITextField]!
    @IBOutlet var subSecondLabels: [UILabel]!
    @IBOutlet var mySubTextFields: [UITextField]!
    @IBOutlet weak var checkAnswersButton: UIButton!
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        for textField in myTextFields {
            textField.text = ""
            textField.backgroundColor = UIColor.white
            textField.isEnabled = true
            textField.viewWithTag(1)?.becomeFirstResponder()
        }
        self.checkAnswersButton.isEnabled = true
    }
    @IBAction func shuffleButtonTapped(_ sender: UIButton) {
        prepareNumbers()
        setupLayout()
        viewWillLayoutSubviews()
        self.checkAnswersButton.isEnabled = true
        for textfield in myTextFields {
            textfield.text = ""
            textfield.backgroundColor = UIColor.white
            textfield.isEnabled = true
            textfield.viewWithTag(1)?.becomeFirstResponder()
        }
    }
    
    @IBAction func checkAnswersButtonTapped(_ sender: UIButton) {
        // Check sums
        for (index, textfield) in mySumTextFields.enumerated() {
            if textfield.text == "" {
                textfield.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            } else {
                if Int(sumFirstLabels[index].text!)! + Int(mySumTextFields[index].text!)! == Int(sumLabels[index].text!)! {
                    textfield.backgroundColor = UIColor.FlatColor.Green.Fern
                    correctAnswers += 1
                    totalAnswers += 1
                } else {
                    textfield.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                    totalAnswers += 1
                }
            }
        }
        // Check subtraction
        for (index, textfield) in mySubTextFields.enumerated() {
            if textfield.text == "" {
                textfield.backgroundColor = UIColor.FlatColor.Red.TerraCotta
            } else {
                if Int(subtractionLabels[index].text!)! - Int(subSecondLabels[index].text!)! == Int(textfield.text!)! {
                    textfield.backgroundColor = UIColor.FlatColor.Green.Fern
                    correctAnswers += 1
                    totalAnswers += 1
                } else {
                    textfield.backgroundColor = UIColor.FlatColor.Red.TerraCotta
                    totalAnswers += 1
                }
            }
        }
        localdata.set(totalAnswers, forKey: "totalAnswers")
        localdata.set(correctAnswers, forKey: "correctAnswers")
        self.viewWillLayoutSubviews()
        for textfield in myTextFields {
            textfield.isEnabled = false
        }
        self.checkAnswersButton.isEnabled = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.countSolved = 7
        if countSolved != 9 {
            // Example data
            self.numberArray = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        }
        for mytextField in myTextFields {
            mytextField.delegate = self
        }
        prepareNumbers()
        setupLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillShow)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillHide)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if countSolved != 7 {
            // show message
            self.sheetView.isUserInteractionEnabled = false
            let notAvailableAlert = UIAlertController(title: NSLocalizedString("Not available yet!", comment: ""), message: NSLocalizedString("Solve all trees up to 10 first.", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString("Back", comment: ""), style: .default, handler: {(_) in
                self.performSegue(withIdentifier: "unwindToViewController", sender: self)})
            notAvailableAlert.addAction(ok)
            present(notAvailableAlert, animated: true, completion: nil)
        } else {
            // show new view
            self.sheetView.isUserInteractionEnabled = true
            for tf in myTextFields {
                tf.viewWithTag(1)?.becomeFirstResponder()
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // calculate and show total score
        let a = localdata.integer(forKey: "correctAnswers")
        let b = localdata.integer(forKey: "totalAnswers")
        var c: Float = 0.0
        if b != 0 {
            c = Float((Float(a) / Float(b)) * 100)
        } else {
            c = 0.0
        }
        self.scoreLabel.text = "\(a)/\(b) (\(String(format: "%.2f", c))%)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout() {
        viewLeft.layer.borderColor = UIColor.black.cgColor
        viewLeft.layer.borderWidth = 2
        viewLeft.layer.cornerRadius = 10
        viewLeft.backgroundColor = UIColor.FlatColor.Blue.BlueWhale
        viewRight.layer.borderColor = UIColor.black.cgColor
        viewRight.layer.borderWidth = 2
        viewRight.layer.cornerRadius = 10
        viewRight.backgroundColor = UIColor.FlatColor.Blue.BlueWhale
        
        self.checkAnswersButton.isEnabled = true
        for button in myButtons {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 10
        }
        
        for textfield in myTextFields {
            textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textfield.layer.borderColor = UIColor.black.cgColor
            textfield.layer.borderWidth = 2
            textfield.layer.cornerRadius = 5
            textfield.textColor = UIColor.FlatColor.Violet.BlueGem
            textfield.minimumFontSize = 1
            textfield.layer.masksToBounds = true
            textfield.backgroundColor = UIColor.white
            textfield.isEnabled = true
            textfield.adjustsFontSizeToFitWidth = true
            textfield.allowsEditingTextAttributes = false
            textfield.sizeToFit()            
        }
        
        // Fill sums
        for (index, sumLabel) in sumLabels.enumerated() {
            let sum = shuffledSumArray[index]
            sumLabel.text = String(sum)
            sumFirstLabels[index].text = String(sumsDict[sum]![0])
            mySumTextFields[index].text = String(sumsDict[sum]![1])
        }
        
        // Fill subtractions
        for (index, subLabel) in subtractionLabels.enumerated() {
            let sum = shuffledMinusArray[index]
            subLabel.text = String(sum)
            subSecondLabels[index].text = String(minusDict[sum]![0])
            mySubTextFields[index].text = String(minusDict[sum]![1])
        }
        
        for label in myLabels {
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.minimumScaleFactor = 0.1
            label.adjustsFontSizeToFitWidth = true            
        }
        for label in myLabelsLeft {
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.minimumScaleFactor = 0.1
            label.adjustsFontSizeToFitWidth = true
        }
        
    }
    
    // MARK: - prepare numbers
    func prepareNumbers() {
        // Score
        if localdata.object(forKey: "totalAnswers") != nil {
            let totaleScore: Int = localdata.integer(forKey: "totalAnswers")
            self.totalAnswers = totaleScore
        } else {
            self.totalAnswers = 0
        }
        if localdata.object(forKey: "correctAnswers") != nil {
            let correctScore: Int = localdata.integer(forKey: "correctAnswers")
            self.correctAnswers = correctScore
        } else {
            self.correctAnswers = 0
        }
        // sort labels
        self.sumFirstLabels = sumFirstLabels.sorted(by: {$0.tag < $1.tag})
        self.mySumTextFields = mySumTextFields.sorted(by: {$0.tag < $1.tag})
        self.sumLabels = sumLabels.sorted(by: {$0.tag < $1.tag})
        self.subtractionLabels = subtractionLabels.sorted(by: {$0.tag < $1.tag})
        self.subSecondLabels = subSecondLabels.sorted(by: {$0.tag < $1.tag})
        self.mySubTextFields = mySubTextFields.sorted(by: {$0.tag < $1.tag})
        // numbers for sum
        shuffledSumArray = shuffleArray(array: self.numberArray)
        for w in 0...8 {
            let sum = shuffledSumArray[w]
            // random x and y (x+y = sum)
            var allNumbersForSum: Array<Int> = []
            for z in 0...sum {
                allNumbersForSum.append(z)
            }
            let randomNumberArray: Array<Int> = shuffleArray(array: allNumbersForSum)
            let x = randomNumberArray[0]
            let y = sum - x
            sumsDict[sum] = [x, y]
        }
        // numbers for subtraction
        shuffledMinusArray = shuffleArray(array: self.numberArray)
        for w in 0...8 {
            let sum = shuffledMinusArray[w]
            var allNumbersForMinus: Array<Int> = []
            for z in 0...sum {
                allNumbersForMinus.append(z)
            }
            let randomNumberArray: Array<Int> = shuffleArray(array: allNumbersForMinus)
            let x = randomNumberArray[0]
            let y = sum - x
            minusDict[sum] = [x, y]
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

    // MARK: - Textfield Delegate
    // MARK: textfield becomes active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.isUserInteractionEnabled = true
        textField.isEnabled = true
        return true
    }
    
    // MARK: keyboard return function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // go to next inputfield
        let nextTag = nextEmptyFieldTag(currentTag: textField.tag)
        if nextTag != 0 {
            for tf in myTextFields {
                tf.viewWithTag(nextTag)?.becomeFirstResponder()
            }
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Check answer and go to next empty textfield
        var correctAnswer: Int = 0
        if textField.tag <= 8 {
            let sum = shuffledSumArray[textField.tag - 1]
            correctAnswer = sumsDict[sum]![1]
        } else {
            let sub = shuffledMinusArray[textField.tag - 9]
            correctAnswer = minusDict[sub]![1]
        }
        if textField.text == String(correctAnswer) {
            let nextTag = nextEmptyFieldTag(currentTag: textField.tag)
            if nextTag != 0 {
                for tf in myTextFields {
                    tf.viewWithTag(nextTag)?.becomeFirstResponder()
                }
            } else {
                self.checkAnswersButtonTapped(checkAnswersButton)
            }
        }
    }
    
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let realOrigin = self.checkAnswersButton.convert(checkAnswersButton.bounds, to: self.view)
            print("frame height = \(self.view.frame.height)")
            print("screen Height = \(screenHeight)")
            print("realOrigin bounds = \(realOrigin)")
            print("keyBoardHeight = \(keyboardSize.height)")
            let bottomSpace = screenHeight - realOrigin.maxY
            let overlap = keyboardSize.height + 44 - bottomSpace
            print("bottomSpace = \(bottomSpace)")
            print("overlap = \(overlap)")
            
            if bottomSpace < keyboardSize.height + 44 {
                print("too high")
                let diff = overlap + 8
                print("difference = \(diff)")
                self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height - diff)
                //self.view.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + diff, 0.0)
                self.view.layoutIfNeeded()
            }
        }
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
    }
}
