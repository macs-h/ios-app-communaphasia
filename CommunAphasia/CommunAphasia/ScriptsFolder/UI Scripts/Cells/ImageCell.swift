//
//  ImageResultViewCell.swift
//  CommunAphasia
//
//  Created by RedSQ on 26/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/// The class for the cell in the `ImageResultCollectionView`. It stores the cell
/// properties and deals with assigning and exporting.
class ImageCell: UICollectionViewCell {
    // Good to manage these variables in the clzass but could be done with an array in
    // the view controller.
    var word: String = "car"
    var type: String = "verb" // for the type of word (noun, verb etc). Could use enums.
    var suggestedWords = [String]()
    var grNum: String = gNum.singlular.rawValue
    var category: String = "Other"
    var tense: String = "current"
    /// Reference to the image on the UI which are changed to reflect the image.
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    /**
     * Takes in a tuple and assigns it to class properties.
     *
     * - Parameter cell:    a tuple containing the following properties:
     *      - word:         the word for the cell.
     *      - type:         the type of word.
     *      - image:        the image to be displayed in the cell.
     *      - suggestions:  possible suggestions which are related to the word.
     */
    func addData(cell: (word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String)) {
        self.word = cell.word
        self.type = cell.type
        self.imageView.image = cell.image
        self.suggestedWords = cell.suggestions
        self.grNum = cell.grNum
        self.category = cell.category
        self.tense = cell.tense
        
        //---colouring boarders---//
        /*if type == "noun"{
         layer.borderColor = UIColor.red.cgColor
         }else{
         layer.borderColor = UIColor.blue.cgColor
         
         }
         layer.borderWidth = 4 //max dont change*/
    }
    
    
    /**
     * Extracts the cell properties and puts it into a tuple.
     *
     *  - Returns: a tuple containing the cell's properties.
     *      - word:         the word for the cell.
     *      - type:         the type of word.
     *      - image:        the image to be displayed in the cell.
     *      - suggestions:  possible suggestions which are related to the word.
     */
    func extractData()-> (word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String) {
        return (self.word, self.type, self.imageView.image!, self.suggestedWords, self.grNum, self.category, self.tense)
    }
    
    func showPlural(){
        let image = UIImage(named: "cow.png")
        let frontImageView = UIImageView(image: image)
        self.contentView.addSubview(imageView)
        frontImageView.frame = imageView.frame
        //frontImageView.frame.offsetBy(dx: 3, dy: 3)
        //imageView.frame = CGRect(x: imageView.frame.x, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
    
    func showTense(tenseType: String) -> UIImage{
        let image = imageView.image
        var tenseImage = UIImage(named: "imagePlaceholder.png")
        if tenseType == "past" {
            tenseImage = UIImage(named: "pastTense.png")!
        }else if tenseType == "present" {
            tenseImage = UIImage(named: "presentTense.png")!
        }else if tenseType == "future"{
            tenseImage = UIImage(named: "futureTense.png")!
        }
        let size = CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
        UIGraphicsBeginImageContext(size)
        //for tense superimposed on image
        //        let finalSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //        let tenseSize = CGRect(x: (size.width - (size.width*0.4))/2, y: size.height-(size.height*0.4), width: (size.width*0.4), height: (size.height*0.4))
        //for tense sitting below image
        let finalSize = CGRect(x: (size.width - (size.width*0.6))/2, y: 0, width: size.width*0.6, height: size.height*0.6)
        let tenseSize = CGRect(x: (size.width - (size.width*0.4))/2, y: size.height-(size.height*0.4), width: (size.width*0.4), height: (size.height*0.4))
        
        image!.draw(in: finalSize, blendMode: CGBlendMode.normal, alpha: 1)
        tenseImage?.draw(in: tenseSize, blendMode: CGBlendMode.normal, alpha: 1)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
