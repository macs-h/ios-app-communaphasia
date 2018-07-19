//
//  TextInput_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

///
/// Handles the text input from the user ...??
///
class TextInput_ViewController: UIViewController {

    /// References the user input text field.
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var stringArray = [String]()
    var attributedString: NSMutableAttributedString?
    
    
    var cells = [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String)]()
    
    func makeCells(words:[String])-> [Int]{
        var errorArray = [Int]()
        //var cells = [ImageTextResultViewCell]()
        var i = 0
        for word in words{
            let tempCell = Utility.instance.getDatabaseEntry(word)
            if tempCell.type == "" {
                errorArray.append(i)
                print("> errorArray: \(errorArray)")
            } else if errorArray.count == 0 {
                
                
                cells.append(tempCell)
            }
            // idea for +... could treat as a cell but just manually chnage the size of the cell in code for every 2nd cell
            
            i += 1
        }
        return errorArray
    }

    func showErrors(_ wordArray: [String], _ errorArray: [Int]) {
        attributedString = NSMutableAttributedString(string: wordArray.joined(separator: " "))
        for index in errorArray {
            attributedString?.setColor(color: UIColor.red, forText: wordArray[index])
        }
        print(">> attributedString:", attributedString)
        
    }
    
    /**
     * Called when the `done` button is pressed.
     *
     *  - Parameter sender: the object which called this function.
     */
    @available(iOS 11.0, *)
    @IBAction func done(_ sender: Any) {
        if textField.text != ""{
            let wordArray = Utility.instance.getSentenceToWords(textField.text!, .whitespaces)
            let errorArray = makeCells(words: wordArray)
            
            
            // ---------------------------------------------------------------------------- //
            var inputString: String = textField.text!
            var NSCount: Int = 0
            
            let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
            tagger.string = inputString
            let range = NSRange(location: 0, length: inputString.utf16.count)
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
                if let tag = tag {
                    let word = (inputString as NSString).substring(with: tokenRange)
//                    inputArray.append(word)
                    print("\(word): \(tag.rawValue)")
                    
                    if cells.count > 0 {
                        if word == cells[NSCount].word {
                            cells[NSCount].type = tag.rawValue
                            print(">\(cells[NSCount].type)")
                            NSCount += 1
                            
                        }
                    }
                }
                
            }
            
            //count = 0
            //NSlin for loop:
            //if NSword == cells[0]
            //cell[loopNum].type = NSword.type
            //count +=1
            
            
            // ---------------------------------------------------------------------------- //
            if errorArray.count > 0{
                showErrors(wordArray, errorArray)
                errorLabel.attributedText = attributedString
                cells.removeAll()
            }else{
                performSegue(withIdentifier: "TIToResult_segue", sender: self)
            }
        
        }
    }

    /** Xcode generated **  @Sam description
     *
     * Notifies the view controller that a segue is about to be performed. Subclasses
     * override this method and use it to configure the new view controller prior to it
     * being displayed.
     *
     * The segue object contains information about the transition, including references
     * to both view controllers that are involved.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TIToResult_segue")
        {
            let resultController = segue.destination as! TextResult_ViewController
            resultController.inputString = textField.text!
            resultController.cellsToBeShown = cells
        }
    }
    
    /** Xcode generated **
     *
     * Called after the controller's view is loaded into memory.
     * This method is called after the view controller has loaded its view hierarchy into
     * memory.
     *
     * You usually override this method to perform additional initialization on views
     * that were loaded from nib files.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    /** Xcode generated **
     *
     * Sent to the view controller when the app receives a memory warning.
     *
     * Your app never calls this method directly. Instead, this method is called when the
     * system determines that the amount of available memory is low.
     *
     * You can override this method to release any additional memory used by your view
     * controller. If you do, your implementation of this method must call the super
     * implementation at some point.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
}







