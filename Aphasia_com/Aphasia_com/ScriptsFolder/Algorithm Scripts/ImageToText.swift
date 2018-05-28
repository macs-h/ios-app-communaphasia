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
        var wordToAppend = ""
        
        for imageNum in 0...pics.count-1 {
            //first word, probably add 'the'
            if (pics[0].type == wordType.noun.rawValue && imageNum==0) {
                wordToAppend = (pics[imageNum].grNum == gNum.singlular.rawValue) ? pics[imageNum].word : pics[imageNum].word + "s"
                returnString.append("The")          // index 0
                returnString.append(wordToAppend)   // index 1
                
            }else{
                let thisPic = pics[imageNum]  // only need to access value once, instead of thrice.
                let prevPic = pics[imageNum-1]
                let nextPic = (imageNum < pics.count-1) ? pics[imageNum+1] : nil
                if thisPic.type == wordType.adjective.rawValue {
                    temp = (prevPic.grNum == gNum.singlular.rawValue) ? "is" : "are"
                    returnString.append(temp)           // index 2
                    returnString.append((thisPic.word))   // index 3
                } else if thisPic.type == wordType.noun.rawValue {
                    wordToAppend = (thisPic.grNum == gNum.singlular.rawValue) ? thisPic.word : thisPic.word + "s"
                    temp = (prevPic.grNum == gNum.singlular.rawValue) ? "is" : "are"
                    returnString.append(temp)           // index 3
                    returnString.append(wordToAppend)   // index 2
                } else if thisPic.type == wordType.verb.rawValue {
                    temp = (prevPic.grNum == gNum.singlular.rawValue) ? "is" : "are"
                    returnString.append(temp)           // index 3
                    returnString.append(thisPic.word)   // index 2
                }
            }
            
        }
//        if pics[0].type == wordType.noun.rawValue {
//            returnString.append("The")          // index 0
//            returnString.append(pics[0].word)   // index 1
//        }
//
//        let pic1Type = pics[1].type  // only need to access value once, instead of thrice.
//        if pic1Type == wordType.adjective.rawValue {
//            temp = (pics[0].grNum == gNum.singlular.rawValue) ? "is" : "are"
//            returnString.append(temp)           // index 2
//            returnString.append(pics[1].word)   // index 3
//        } else if pic1Type == wordType.noun.rawValue {
//            temp = (pics[0].grNum == gNum.singlular.rawValue) ? "is" : "are"
//            returnString.append(pics[1].word)   // index 2
//            returnString.append(temp)           // index 3
//        } else if pic1Type == wordType.verb.rawValue {
//            temp = (pics[0].grNum == gNum.singlular.rawValue) ? "is" : "are"
//            returnString.append(pics[1].word)   // index 2
//            returnString.append(temp)           // index 3
//        }
        
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

