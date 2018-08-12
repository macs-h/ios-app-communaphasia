//
//  TextInput_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit


class TextInput_ViewController: UIViewController {

    /// References the user input text field.
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var stringArray = [String]()
    var attributedString: NSMutableAttributedString?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var cells = [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String)]()
    //var cells = [ImageCell]() - intending to change this later to hold cells instead of tuples
    
    @available(iOS 11.0, *)
    func makeCells(using words:[String], from original:[String])-> [Int]{
        var errorArray = [Int]()
        let originalLemmaTagged = Utility.instance.lemmaTag(inputString: original.joined(separator: " "))
        var i = 0
        for word in words{
//            print(originalLemmaTagged)
            let lemmaWord = originalLemmaTagged[ original.index(of: word)! ]
//            let tempCell = Utility.instance.getDatabaseEntry(lemmaWord)
            
            if Utility.instance.isInDatabase(word: lemmaWord) == false{
                errorArray.append(original.index(of: word)!)
                print("SYN:", Utility.instance.getSynonym(lemmaWord))
                
            } else if errorArray.count == 0 {
                let tempCell = Utility.instance.getDatabaseEntry(lemmaWord)
                cells.append(tempCell)
            }
            
            // idea for +... could treat as a cell but just manually chnage the size of the cell in code for every 2nd cell
            
            i += 1
        }
        return errorArray
    }

    
    func showErrors(_ wordArray: [String], _ errorArray: [Int], _ inputArray: [String]) {
        attributedString = NSMutableAttributedString(string: wordArray.joined(separator: " "))
        for index in errorArray {
            attributedString?.setColor(color: UIColor.red, forText: wordArray[index])
        }
        print(">> attributedString:", attributedString!)
        
    }
    
    
    /**
     * Called when the `done` button is pressed.
     *
     *  - Parameter sender: the object which called this function.
     */
    @available(iOS 11.0, *)
    @IBAction func done(_ sender: Any) {
        if textField.text != ""{
            let inputArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces, removeSelectWords: false)
            let wordArray = Utility.instance.getSentenceToWords(from: textField.text!, separatedBy: .whitespaces)
            let errorArray = makeCells(using: wordArray, from: inputArray)
                
            if errorArray.count > 0{
//                showErrors(wordArray, errorArray)
                showErrors(inputArray, errorArray, inputArray)
                errorLabel.attributedText = attributedString
                cells.removeAll()
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
        
        if gesture.didTapAttributedTextInLabel(label: errorLabel, inRange: dogRange){
            print("dog Error Tapped")
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}





