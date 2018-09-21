//
//  TextInput_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    Class that controls the Text input screen.
 */
class TextInput_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // References the user input text field.
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var synonymLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
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
    
    
    /**
        Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    
    /**
        The number of columns of data in picker view.
     
        - Parameter pickerView: the `pickerView`.
     
        - Returns:  the number of columns in the picker view.
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    /**
        The number of rows of data in picker view.
     
        - Parameters:
            - pickerView:   the `pickerView`.
            - component:    the column in which to count the rows.
     
        - Returns:  the number of rows in selected column
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    /**
        The data to return for the row and component (column) that's being
        passed in, in picker view.
     
        - Parameters:
            - pickerView:   the `pickerView`.
            - row:          the selected row.
            - component:    the selected column.
     
        - Returns:  (Optional) the string held in the selected row and column
                    if any exists.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    /**
        When the user selects the next button the selected error (unfound word)
        in the text field moves to the right. The previous selection will turn
        green if it is in the database and red if not.
        The current selection will also turn blue.
     
        - Parameter sender: The object which called this function.
    */
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if Utility.instance.isInDatabase(word: stringArray[currentIndex]) {
            attributedArray[currentIndex].setColor(color: UIColor.green, forText: attributedArray[currentIndex].string)
        }else{
            attributedArray[currentIndex].setColor(color: UIColor.red, forText: attributedArray[currentIndex].string)
        }
        
        if currentIndex < errorIndices[errorIndices.count-1] {
            
            errorIndex += 1
            currentIndex = errorIndices[errorIndex]
            
            if Utility.instance.isInDatabase(word: stringArray[currentIndex]){
                synonymLabel.text = "'" + stringArray[currentIndex] + "' is valid!"
            }else{
                synonymLabel.text = "Cant find '" + stringArray[currentIndex] + "', try one of these:"
            }
            pickerData = synonyms[errorIndex]
            pickerData.append(String(errorIndex))
            pickerView.reloadAllComponents()
            
            attributedArray[currentIndex].setColor(color: UIColor.blue, forText: attributedArray[currentIndex].string)
            setTextFromArray()
        }
        
    }
    
    
    /**
        When the user selects the next button the selected error (unfound word)
        in the text field moves to the left. The previous selection will turn
        green if it is in the database and red if not.
        The current selection will also turn blue.
     
        - Parameter sender: The object which called this function.
     */
    @IBAction func prevButtonPressed(_ sender: Any) {
        
        if Utility.instance.isInDatabase(word: stringArray[currentIndex]) {
            attributedArray[currentIndex].setColor(color: UIColor.green, forText: attributedArray[currentIndex].string)
        }else{
            attributedArray[currentIndex].setColor(color: UIColor.red, forText: attributedArray[currentIndex].string)
        }
        if currentIndex > errorIndices[0] {
            
            errorIndex -= 1
            currentIndex = errorIndices[errorIndex]
            
            if Utility.instance.isInDatabase(word: stringArray[currentIndex]){
                synonymLabel.text = "'" + stringArray[currentIndex] + "' is valid!"
            }else{
                synonymLabel.text = "Cant find '" + stringArray[currentIndex] + "', try one of these:"
            }
            pickerData = synonyms[errorIndex]
            pickerData.append(String(errorIndex))
            pickerView.reloadAllComponents()
            
            attributedArray[currentIndex].setColor(color: UIColor.blue, forText: attributedArray[currentIndex].string)
            setTextFromArray()
        }
    }
    
    
    /**
        This function changes the selected word in the text field depending on
        what the user selects in the `pickerView` (scroll thingy).
     
        - Parameters:
            - pickerView:   the `pickerView`.
            - row:          the row of the `pickerView` selected by the user.
            - component:    the component which is selected.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        attributedArray[currentIndex] = NSMutableAttributedString(string: pickerData[row])
        attributedArray[currentIndex].setColor(color: UIColor.blue, forText: attributedArray[currentIndex].string)
        setTextFromArray()
        stringArray[currentIndex] = pickerData[row]
        //need to display attributed array in the text field
        //textField.text = stringArray.joined(separator: " ")
    }
    
    
    /**
        This function iterates through the array of attributed strings and
        adds them to a temporary string to be displayed in the text field then
        updates the text field with the changes.
     */
    func setTextFromArray(){
        let tempString = NSMutableAttributedString()
        for i in 0...attributedArray.count-1{
            tempString.append(attributedArray[i])
            tempString.append(NSMutableAttributedString(string: " "))
        }
        textField.attributedText = tempString
    }
    
    
    /**
        Makes an array of cells based on the input words and checks whether
        they exist in the database. It then retunrs the indices of the words
        which do not appear in the database.
     
        - Parameters:
            - wordArray:    An array of words (retrieved from the text field
                            and processed).
            - original:     The origional words (from the text field).
     
        - Returns:  an array containing the indices of the words which do not
                    exist in the database.
     */
    @available(iOS 11.0, *)
    func makeCells(using wordArray:[String], from original:[String])-> [Int] {
        var errorArray = [Int]()
        errors = []
        let originalArray = original.map { $0.lowercased() }
        let originalLemmaTagged = Utility.instance.lemmaTag(inputString: originalArray.joined(separator: " "))

        loadingSpinner.startAnimating()// Start loading wheel.
        
        for word in wordArray {
            if wordArray.isEmpty && errorArray.isEmpty {
                invalidSentence()
                return []
            } else {
                let lemmaWord = originalLemmaTagged[ originalArray.index(of: word.lowercased())! ]
                
                if Utility.instance.isInDatabase(word: lemmaWord) == false{
                    errorArray.append(originalArray.index(of: word)!)
                    errors.append(word)
                } else if errorArray.count == 0 {
                    let tempCell = Utility.instance.getDatabaseEntry(lemmaWord)
                    cells.append(tempCell)
                }
            
            // idea for +... could treat as a cell but just manually chnage the size of the cell in code for every 2nd cell

            }
        }
        
        loadingSpinner.stopAnimating() // End loading wheel.
        
        return errorArray
    }


    
    /**
        Lets the user know that the sentence they entered is invalid.
     */
    func invalidSentence() {
        let str = "Please enter a valid sentence"
        attributedString = NSMutableAttributedString(string: str)
        attributedString?.setColor(color: UIColor.red, forText: str)
        synonymLabel.isHidden = false
        synonymLabel.attributedText = attributedString
        cells.removeAll()
    }
    
    
    /**
        This function executes when the user has finished typing their sentence
        and taps the done button. It checks that the words entered are valid
        and in the database and if they are not it will display them to the
        user in the text field.
     
        - Parameter sender: The object which called this function.
     */
    @available(iOS 11.0, *)
    @IBAction func done(_ sender: Any) {
        stringArray = (textField.text?.components(separatedBy: " "))!
        pickerView.endEditing(true)
        pickerView.isHidden = true
        synonymLabel.isHidden = true
        attributedString = NSMutableAttributedString()
        attributedArray.removeAll()
        errorIndex = 0
        
        if textField.text != ""{
            let inputArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces, removeSelectWords: false).filter({ $0 != ""})
            print(inputArray)
            let wordArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces).filter({ $0 != ""})
            //loadingSpinner.startAnimating()
            print("animation started")
            let errorArray = makeCells(using: wordArray, from: inputArray)
            
            for word in errorArray{
                print("\(word) \(inputArray[word])")
            }
            
            if errorArray.count > 0 {
                //showErrors(inputArray, errorArray, inputArray)
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
                            let contraction = Utility.instance.lemmaTag(inputString: inputArray[index])
                            availableSynonyms.append(contraction.joined(separator: " "))
                        }
                        availableSynonyms.append(contentsOf: ["man","eat","cat"])
                        synonyms.append(availableSynonyms)
                    } else {
                        print("Internet Connection not Available!")
                    }

                }
                //do things with sysnonyms
                if Utility.instance.isInDatabase(word: errors[errorIndex]){
                    synonymLabel.text = "'" + errors[errorIndex] + "' is valid!"
                }else{
                    synonymLabel.text = "Cant find '" + errors[errorIndex] + "', try one of these:"
                }
                synonymLabel.isHidden = false
                
                pickerData = synonyms[errorIndex]
                pickerData.append(String(errorIndex))
                currentIndex = errorArray[0]
                errorIndices = errorArray
               print("------- currentIndex", currentIndex)
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
                print("------- error array end", errorArray)
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
            //loadingSpinner.stopAnimating()
        }
    }
    

    /**
        Notifies the view controller that a segue is about to be performed.
     
        - Parameters:
            - segue:    The segue object containing information about the view
                        controllers involved in the segue.
            - sender:   The object that initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TIToResult_segue")
        {
            let resultController = segue.destination as! TextResult_ViewController
            resultController.inputString = textField.text!
            resultController.cellsToBeShown = cells
        }
    }
    
    
    /**
        Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
} // End of TextInput_ViewController class!





