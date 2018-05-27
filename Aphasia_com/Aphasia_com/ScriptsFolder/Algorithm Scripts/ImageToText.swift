//
//  ImageToText.swift
//  CommunAphasia
//
//  Created by RedSQ 24/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//
import UIKit
import Foundation

class ImageToText {
    static let sharedInstance = ImageToText()
var cell: ImageSelectViewCell?
    
    private init(){
        print("imageToText class Init")
    }

    func createSentence(pics: [SelectedImageViewCell]){
        var returnString:[String] = []
        
        if pics[0].type == "noun" {
            returnString[0] = "The"
            returnString[1] = pics[0].word
        }

        if pics[1].type == "adj" {
            if pics[0].num == "singular" {
                returnString[2] = "is"
            }
            if pics[0].num == "plural" {
                returnString[2] = "are"
            }
            returnString[3] = pics[1].word
        }
        if pics[1].type == "noun" {
            if pics[0].num == "singular" {
                returnString[3] = "is"
            }
            if pics[0].num == "plural" {
                returnString[3] = "are"
            }
            returnString[2] = pics[1].word
        }
        if pics[1].type == "verb" {
            if pics[0].num == "singular" {
                returnString[3] = "is"
            }
            if pics[0].num == "plural" {
                returnString[3] = "are"
            }
            returnString[2] = pics[1].word
        }
        return returnString
    }
}

