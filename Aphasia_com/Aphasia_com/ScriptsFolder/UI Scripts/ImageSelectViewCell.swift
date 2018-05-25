//
//  ImageSelectViewCell.swift
//  Aphasia_com
//
//  Created by Sam Paterson on 21/05/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

class SelectViewCell: UICollectionViewCell {
    //good to manage these variables in the class but could be done with an array in the view controller
    var word: String = "car"
    var type: String = "verb" //for the type of word (noun, verb etc)
    
    @IBOutlet weak var imageView: UIImageView!
    
    var suggestedWords = [String]()
    //
    
    
    //----------max---- look how to pass a tuple as a param
    func addData(_ word: String, _ type: String, _ image: UIImage ,_ suggestions: [String]){
        self.word = word
        self.type = type
        self.imageView.image = image
        self.suggestedWords = suggestions
        
        //---colouring boarders---//
        if type == "noun"{
            layer.borderColor = UIColor.red.cgColor
        }else{
            layer.borderColor = UIColor.blue.cgColor
            
        }
        layer.borderWidth = 4 //max dont change
    }
    
    func extractData()-> (word: String, type: String, image: UIImage, suggestions: [String]){
        let word = self.word
        let type = self.type
        let suggestions = self.suggestedWords
        let image = self.imageView.image!
        return (word, type, image, suggestions)
    }
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    
   
}
