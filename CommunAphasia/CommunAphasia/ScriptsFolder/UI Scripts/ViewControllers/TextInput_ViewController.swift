//
//  TextInput_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit


class TextInput_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    /// References the user input text field.
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var synonymLabel: UILabel!
    
    var stringArray = [String]()
    var currentIndex:Int = 0
    var errorIndices = [Int]()
    
    var attributedArray = [NSMutableAttributedString]()
    
    var attributedString: NSMutableAttributedString?
    var errors = [String]()
    var errorIndex: Int = 0
    var synonyms = [[String]]()
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData:[String] = []
    var cells = [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String)]()
    //var cells = [ImageCell]() - intending to change this later to hold cells instead of tuples
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    // The number of columns of data in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in, in picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if Utility.instance.isInDatabase(word: stringArray[currentIndex]) {
            attributedArray[currentIndex].setColor(color: UIColor.green, forText: attributedArray[currentIndex].string)
        }else{
            attributedArray[currentIndex].setColor(color: UIColor.red, forText: attributedArray[currentIndex].string)
        }
        
        if currentIndex < errorIndices[errorIndices.count-1] {
            
            errorIndex += 1
            currentIndex = errorIndices[errorIndex]
            
            synonymLabel.text = "Cant find '" + stringArray[currentIndex] + "', try one of these:"
            pickerData = synonyms[errorIndex]
            pickerData.append(String(errorIndex))
            pickerView.reloadAllComponents()
            
            attributedArray[currentIndex].setColor(color: UIColor.blue, forText: attributedArray[currentIndex].string)
            setTextFromArray()
        }
        
    }
    @IBAction func prevButtonPressed(_ sender: Any) {
        
        if Utility.instance.isInDatabase(word: stringArray[currentIndex]) {
            attributedArray[currentIndex].setColor(color: UIColor.green, forText: attributedArray[currentIndex].string)
        }else{
            attributedArray[currentIndex].setColor(color: UIColor.red, forText: attributedArray[currentIndex].string)
        }
        if currentIndex > errorIndices[0] {
            
            errorIndex -= 1
            currentIndex = errorIndices[errorIndex]
            
            synonymLabel.text = "Cant find '" + stringArray[currentIndex] + "', try one of these:"
            pickerData = synonyms[errorIndex]
            pickerData.append(String(errorIndex))
            pickerView.reloadAllComponents()
            
            attributedArray[currentIndex].setColor(color: UIColor.blue, forText: attributedArray[currentIndex].string)
            setTextFromArray()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        attributedArray[currentIndex] = NSMutableAttributedString(string: pickerData[row])
        attributedArray[currentIndex].setColor(color: UIColor.blue, forText: attributedArray[currentIndex].string)
        setTextFromArray()
        stringArray[currentIndex] = pickerData[row]
        //need to display attributed array in the text field
        //textField.text = stringArray.joined(separator: " ")
        
    }
    
    func setTextFromArray(){
        let tempString = NSMutableAttributedString()
        for i in 0...attributedArray.count-1{
            tempString.append(NSMutableAttributedString(string: " "))
            tempString.append(attributedArray[i])
        }
        textField.attributedText = tempString
    }
    
    @available(iOS 11.0, *)
    func makeCells(using wordArray:[String], from original:[String])-> [Int]{
        var errorArray = [Int]()
        errors = []
        let originalArray = original.map { $0.lowercased() }
        let originalLemmaTagged = Utility.instance.lemmaTag(inputString: originalArray.joined(separator: " "))
//        var i = 0
        // Start loading wheel.
        
        for word in wordArray {
            if wordArray.isEmpty && errorArray.isEmpty {
                invalidSentence()
                return []
            } else {
                let lemmaWord = originalLemmaTagged[ originalArray.index(of: word.lowercased())! ]
                
                if Utility.instance.isInDatabase(word: lemmaWord) == false{
                    errorArray.append(original.index(of: word)!)
                    errors.append(word)
                } else if errorArray.count == 0 {
                    let tempCell = Utility.instance.getDatabaseEntry(lemmaWord)
                    cells.append(tempCell)
                }
            
            // idea for +... could treat as a cell but just manually chnage the size of the cell in code for every 2nd cell
            
//            i += 1
            }
        }
        // End loading wheel.
        
        return errorArray
    }

    
//    func showErrors(_ wordArray: [String], _ errorArray: [Int], _ inputArray: [String]) {
//        attributedString = NSMutableAttributedString(string: wordArray.joined(separator: " "))
//        for index in errorArray {
//            attributedString?.setColor(color: UIColor.red, forText: wordArray[index])
//        }
//        print(">> attributedString:", attributedString!.string)
//
//    }
    
//    func testFunc(_ inString: String) {
////        let eLabel = in
//        attributedString = NSMutableAttributedString(string: inString)
//        attributedString?.setColor(color: UIColor.red, forText: inString)
//    }
    
    func invalidSentence() {
        let str = "Please enter a valid input"
        attributedString = NSMutableAttributedString(string: str)
        attributedString?.setColor(color: UIColor.red, forText: str)
        synonymLabel.isHidden = false
        synonymLabel.attributedText = attributedString
        cells.removeAll()
    }
    
    
    /**
     * Called when the `done` button is pressed.
     *
     *  - Parameter sender: the object which called this function.
     */
    @available(iOS 11.0, *)
    @IBAction func done(_ sender: Any) {
        stringArray = (textField.text?.components(separatedBy: " "))!
        pickerView.endEditing(true)
        pickerView.isHidden = true
        synonymLabel.isHidden = true
        errorIndex = 0
        
        if textField.text != ""{
            let inputArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces, removeSelectWords: false).filter({ $0 != ""})
            let wordArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces).filter({ $0 != ""})
            let errorArray = makeCells(using: wordArray, from: inputArray)
                
            if errorArray.count > 0 {
                //showErrors(inputArray, errorArray, inputArray)
                textField.attributedText = attributedString
                cells.removeAll()
                
                for index in errorArray{
                    var availableSynonyms: [String] = []
                    // Check internet connection availability.
                    if Utility.instance.isConnectedToNetwork(){
                        print("Internet Connection Available!")
                        
                        if let synonyms = Utility.instance.getSynonym(inputArray[index]) {
                            print("SYN:", synonyms)
                            availableSynonyms = Utility.instance.synonymsInDataBase(from: synonyms)
                            //availableSynonyms.append("test")
                            
                            print("available sysnonyms:",availableSynonyms)
                        } else {
                            print("No synonyms found") // handle this?
                        }
                        availableSynonyms.append(contentsOf: ["man","eat","cat"])
                        synonyms.append(availableSynonyms)
                    } else {
                        print("Internet Connection not Available!")
                    }

                }
                //do things with sysnonyms
                synonymLabel.text = "Cant find '" + errors[errorIndex] + "', try one of these:"
                synonymLabel.isHidden = false
                
                pickerData = synonyms[errorIndex]
                pickerData.append(String(errorIndex))
                currentIndex = errorArray[0]
                errorIndices = errorArray
                
                pickerView.reloadAllComponents()
                pickerView.isHidden = false
                
                nextButton.isHidden = false
                prevButton.isHidden = false
                for word in stringArray {
                    let atWord = NSMutableAttributedString(string: word)
                    if errors.contains(word){
                        atWord.setColor(color: UIColor.red, forText: atWord.string)
                    }
                    attributedArray.append(atWord)
                }
                attributedArray[errorIndices[0]].setColor(color: UIColor.blue, forText: attributedArray[errorIndices[0]].string)
                setTextFromArray()
            } else {
                var inputString: String = textField.text!
                var NSCount: Int = 0
                
                let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
                tagger.string = inputString
                tagger.enumerateTags(in: NSRange(location: 0, length: inputString.utf16.count),
                                     unit: .word,
                                     scheme: .lexicalClass,
                                     options: [.omitPunctuation, .omitWhitespace])
                { tag, tokenRange, _ in
                    if let tag = tag {
                        let word = (inputString as NSString).substring(with: tokenRange)
                        
                        print("\(word): \(tag.rawValue)")
                        
                        if cells.count > 0 {
//                            print(">> NSCount:", NSCount)
                            if word == cells[NSCount].word {
                                cells[NSCount].type = tag.rawValue
                                print(">\(cells[NSCount].type)")
                                NSCount += 1
                                
                            }
                        }
                    }
                    
                }
            
                performSegue(withIdentifier: "TIToResult_segue", sender: self)
            }
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TIToResult_segue")
        {
            let resultController = segue.destination as! TextResult_ViewController
            resultController.inputString = textField.text!
            resultController.cellsToBeShown = cells
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}




