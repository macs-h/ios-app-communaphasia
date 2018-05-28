//
//  ImageSelectViewCell.swift
//  CommunAphasia
//
//  Created by RedSQ on 21/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/// Description of class.  @Sam description
/// What does it do?
class ImageSelectViewCell: UICollectionViewCell {
    
    // good to manage these variables in the class but could be done with an array in the view controller
    var word: String = "car"
    var type: String = "verb" // for the type of word (noun, verb etc). Could use enums.
    var gNum = ""
    /// What does this do? -----------
    @IBOutlet weak var imageView: UIImageView!
    var suggestedWords = [String]()
    
    
    /**
     * Description of what this function does.  @Sam description
     *
     * - Parameter cell:    a tuple containing the following properties:
     *      - word:         ??
     *      - type:         ??
     *      - image:        ??
     *      - suggestions:  ??
     */
    func addData(cell: (word: String, type: String, gNum: String ,image: UIImage , suggestions: [String])){
        self.word = cell.word
        self.type = cell.type
        self.imageView.image = cell.image
        self.suggestedWords = cell.suggestions
        
        //---colouring boarders---//
        /*if type == "noun"{
            layer.borderColor = UIColor.red.cgColor
        }else{
            layer.borderColor = UIColor.blue.cgColor
            
        }
        layer.borderWidth = 4 //max dont change*/
    }
    
    
    /**
     * Description of what this function does.  @Sam description
     *
     *  - Returns: a tuple containing ....??
     *      - word:         the word describing the entry.
     *      - type:         the type of image (e.g. noun, adjective, etc.).
     *      - image:        the `UIImage` element.
     *      - suggestions:  possible suggestions which are related to the word.
     *
     * ----------------
     *  @Sam check the description of these return types.
     * ----------------
     */
    func extractData()-> (word: String, type: String, gNum: String, image: UIImage, suggestions: [String]) {
        let word = self.word
        let type = self.type
        let gNum = self.gNum
        let suggestions = self.suggestedWords
        let image = self.imageView.image!
        
        return (word, type, gNum,image, suggestions)
    }
    
}
