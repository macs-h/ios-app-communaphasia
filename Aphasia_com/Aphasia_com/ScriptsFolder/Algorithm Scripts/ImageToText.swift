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
    static let instance = ImageToText()
    var cell: ImageSelectViewCell?

    private init(){
        print("imageToText class Init")
    }

    func createSentence(pics: [SelectedImageViewCell]) -> String {
//        var returnString:[String] = []
        var returnString:Array<String> = []
        var temp:String = ""
        
        if pics[0].type == wordType.noun.rawValue {
            returnString.append("The")          // index 0
            returnString.append(pics[0].word)   // index 1
        }
        
        let pic1Type = pics[1].type  // only need to access value once, instead of thrice.
        if pic1Type == wordType.adjective.rawValue {
            temp = (pics[0].grNum == gNum.singlular.rawValue) ? "is" : "are"
            returnString.append(temp)           // index 2
            returnString.append(pics[1].word)   // index 3
        } else if pic1Type == wordType.noun.rawValue {
            temp = (pics[0].grNum == gNum.singlular.rawValue) ? "is" : "are"
            returnString.append(pics[1].word)   // index 2
            returnString.append(temp)           // index 3
        } else if pic1Type == wordType.verb.rawValue {
            temp = (pics[0].grNum == gNum.singlular.rawValue) ? "is" : "are"
            returnString.append(pics[1].word)   // index 2
            returnString.append(temp)           // index 3
        }
        
        // ----------------------------------------------------------------------------
        // Above code is the same as below. @Winston please check.
        // ----------------------------------------------------------------------------

//        if pics[0].type == "noun" {
//            returnString[0] = "The"
//            returnString[1] = pics[0].word
//        }
//
//        if pics[1].type == "adj" {
//            if pics[0].num == "singular" {
//                returnString[2] = "is"
//            }
//            if pics[0].num == "plural" {
//                returnString[2] = "are"
//            }
//            returnString[3] = pics[1].word
//        }
//        if pics[1].type == "noun" {
//            if pics[0].num == "singular" {
//                returnString[3] = "is"
//            }
//            if pics[0].num == "plural" {
//                returnString[3] = "are"
//            }
//            returnString[2] = pics[1].word
//        }
//        if pics[1].type == "verb" {
//            if pics[0].num == "singular" {
//                returnString[3] = "is"
//            }
//            if pics[0].num == "plural" {
//                returnString[3] = "are"
//            }
//            returnString[2] = pics[1].word
//        }
        return returnString.joined(separator: " ")
    }
}

