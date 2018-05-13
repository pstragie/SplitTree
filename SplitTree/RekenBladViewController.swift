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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("countSolved = \(countSolved)")
        print("numberArray = \(numberArray)")
        
        if countSolved != 9 {
            // show message
            self.sheetView.isUserInteractionEnabled = true
            let notAvailableAlert = UIAlertController(title: NSLocalizedString("Not available yet!", comment: ""), message: NSLocalizedString("Solve all trees up to 10 first.", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "Back", style: .default, handler: {(_) in
                self.performSegue(withIdentifier: "unwindToViewController", sender: self)})
            notAvailableAlert.addAction(ok)
            //present(notAvailableAlert, animated: true, completion: nil)
        } else {
            // show new view
            self.sheetView.isUserInteractionEnabled = true
        }
        
    }
    
    override func viewWillLayoutSubviews() {
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
        viewRight.layer.borderColor = UIColor.black.cgColor
        viewRight.layer.borderWidth = 2
        viewRight.layer.cornerRadius = 10
        
        self.checkAnswersButton.isEnabled = true
        for button in myButtons {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 10
        }
        
        for textfield in myTextFields {
            textfield.layer.borderColor = UIColor.black.cgColor
            textfield.layer.borderWidth = 2
            textfield.layer.cornerRadius = 10
            textfield.textColor = UIColor.FlatColor.Violet.BlueGem
            textfield.layer.masksToBounds = true
            textfield.backgroundColor = UIColor.white
            textfield.isEnabled = true
        }
        // Fill sums
        let sumsInDict: Array<Int> = Array(sumsDict.keys)
        for (index, sumLabel) in sumLabels.enumerated() {
            let sum = sumsInDict[index]
            sumLabel.text = String(sum)
            sumFirstLabels[index].text = String(sumsDict[sum]![0])
            mySumTextFields[index].text = String(sumsDict[sum]![1])
        }
        
        // Fill subtractions
        let subsInDict: Array<Int> = Array(minusDict.keys)
        for (index, subLabel) in subtractionLabels.enumerated() {
            let sum = subsInDict[index]
            subLabel.text = String(sum)
            subSecondLabels[index].text = String(minusDict[sum]![0])
            mySubTextFields[index].text = String(minusDict[sum]![1])
        }
        
        for label in myLabels {
            label.textAlignment = .center
        }
        for label in myLabelsLeft {
            label.textAlignment = .center
        }
        
    }
    
    func prepareNumbers() {
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
        print("textFieldShouldReturn")
        let nextTag = textField.tag + 1
        for tf in myTextFields {
            tf.viewWithTag(nextTag)?.becomeFirstResponder()
        }
        return true
    }
}
