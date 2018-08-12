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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var synonymLabel: UILabel!
    
    var stringArray = [String]()
    var attributedString: NSMutableAttributedString?
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData:[String] = []
    var currentError:String = ""
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let text = textField.text
        attributedString = NSMutableAttributedString(string: (text?.replacingOccurrences(of: currentError, with: pickerData[row]))!)
        attributedString?.setColor(color: UIColor.blue, forText: pickerData[row])
        errorLabel.attributedText = attributedString
        textField.attributedText = attributedString
        currentError = pickerData[row]
    }
    
    @available(iOS 11.0, *)
    func makeCells(using words:[String], from original:[String])-> [Int]{
        var errorArray = [Int]()
        let originalArray = original.map { $0.lowercased() }
        let originalLemmaTagged = Utility.instance.lemmaTag(inputString: originalArray.joined(separator: " "))
        var i = 0
        
        for word in words{
            let lemmaWord = originalLemmaTagged[ originalArray.index(of: word.lowercased())! ]
            
            if Utility.instance.isInDatabase(word: lemmaWord) == false{
                errorArray.append(original.index(of: word)!)
                
            } else if errorArray.count == 0 {
                let tempCell = Utility.instance.getDatabaseEntry(lemmaWord)
                cells.append(tempCell)
            }
            
            // idea for +... could treat as a cell but just manually chnage the size of the cell in code for every 2nd cell
            
            i += 1
        }
        // End loading wheel.
        
        return errorArray
    }

    
    func showErrors(_ wordArray: [String], _ errorArray: [Int], _ inputArray: [String]) {
        attributedString = NSMutableAttributedString(string: wordArray.joined(separator: " "))
        for index in errorArray {
            attributedString?.setColor(color: UIColor.red, forText: wordArray[index])
        }
        print(">> attributedString:", attributedString!.string)
        
    }
    
    
    /**
     * Called when the `done` button is pressed.
     *
     *  - Parameter sender: the object which called this function.
     */
    @available(iOS 11.0, *)
    @IBAction func done(_ sender: Any) {
        pickerView.endEditing(true)
        pickerView.isHidden = true
        synonymLabel.isHidden = true
        
        if textField.text != ""{
            let inputArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces, removeSelectWords: false)
            let wordArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces)
            let errorArray = makeCells(using: wordArray, from: inputArray)
                
            if errorArray.count > 0{
//                showErrors(wordArray, errorArray)
                showErrors(inputArray, errorArray, inputArray)
                errorLabel.attributedText = attributedString
                cells.removeAll()
                errorLabel.isUserInteractionEnabled = true
                
                pickerView.endEditing(false)
                pickerView.isHidden = false
                synonymLabel.isHidden = false
                
                for index in errorArray{
                    currentError = inputArray[index]
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
                    } else {
                        print("Internet Connection not Available!")
                    }
                    //do things with sysnonyms
                    synonymLabel.text = "Cant find '" + inputArray[index] + "', try one of these:"
                    pickerData = availableSynonyms
                    pickerView.reloadAllComponents()
                }
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
    
    @IBAction func errorTapped(gesture: UITapGestureRecognizer){
        let text = (errorLabel.text)!
        let dogRange = (text as NSString).range(of: "dog")
        let foxRange = (text as NSString).range(of: "fox")
        
        if gesture.didTapAttributedTextInLabel(label: errorLabel, inRange: dogRange){
            print("dog Error Tapped")
        }else if gesture.didTapAttributedTextInLabel(label: errorLabel, inRange: foxRange){
            print("fox Error Tapped")
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

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
    
        print("touched",self.location(in: label))
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y);
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        print("target:",targetRange.description, "charIndex:",indexOfCharacter.description)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}





