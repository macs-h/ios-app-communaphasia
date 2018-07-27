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
            print(pics[imageNum].grNum)
            //first word, probably add 'the'
            if imageNum==0 {
                if (pics[0].type == wordType.adjective.rawValue || pics[0].type == wordType.noun.rawValue){
                    //print(pics[0].grNum) //bug bc adjectives have plural tag
                    returnString.append("The")          // index 0
                    returnString.append((pics[0].grNum == gNum.plural.rawValue) ? pics[0].word + "s" : pics[0].word)   // index 1
                }else {
                    returnString.append(pics[0].word)
                }
            }else{
                let thisPic = pics[imageNum]  // only need to access value once, instead of thrice.
                let prevPic = pics[imageNum-1]
                //let nextPic = (imageNum < pics.count-1) ? pics[imageNum+1] : nil
                
                if thisPic.type == wordType.noun.rawValue {
                    temp = isNoun(prevWord: prevPic)
                    wordToAppend = (thisPic.grNum == gNum.singlular.rawValue) ? thisPic.word : thisPic.word + "s"
                    returnString.append(temp)
                    returnString.append(wordToAppend)
                }else if thisPic.type == wordType.adjective.rawValue {
                    temp = isAdj(prevWord: prevPic)
                    returnString.append(temp)
                    returnString.append(thisPic.word)
                }else if thisPic.type == wordType.verb.rawValue {
                    temp = isVerb(prevWord: prevPic)
                    returnString.append(temp)
                    returnString.append((prevPic.type == wordType.modal.rawValue) ? String(thisPic.word.dropLast(3)) : thisPic.word)
                }else if thisPic.type == wordType.modal.rawValue {
                    returnString.append(thisPic.word)
                }else{
                    returnString.append(thisPic.word)
                }
                
//                if thisPic.type == wordType.adjective.rawValue {
//                    temp = (prevPic.grNum == gNum.singlular.rawValue) ? "is" : "are"
//                    returnString.append(temp)           // index 2
//                    returnString.append((thisPic.word))   // index 3
//                } else if thisPic.type == wordType.noun.rawValue {
//                    wordToAppend = (thisPic.grNum == gNum.singlular.rawValue) ? thisPic.word : thisPic.word + "s"
//                    temp = (prevPic.grNum == gNum.singlular.rawValue) ? "is" : "are"
//                    returnString.append(temp)           // index 3
//                    returnString.append(wordToAppend)   // index 2
//                } else if thisPic.type == wordType.verb.rawValue {
//                    temp = (prevPic.grNum == gNum.singlular.rawValue) ? "is" : "are"
//                    returnString.append(temp)           // index 3
//                    returnString.append(thisPic.word)   // index 2
//                }
            }
            
        }
        return returnString.joined(separator: " ")
    }
    
    func isNoun(prevWord: SelectedImageViewCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
            temp = "the"
        }else if prevWord.type == wordType.noun.rawValue {
            temp = (prevWord.grNum == gNum.plural.rawValue) ? "are the" : "is the"
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ""
        }else if prevWord.type == wordType.pronoun.rawValue {
            temp = "am the"
        }else if prevWord.type == wordType.modal.rawValue {
            temp = "the"
        }
        return temp
    }
    func isAdj(prevWord: SelectedImageViewCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
            temp = "the"
        }else if prevWord.type == wordType.noun.rawValue {
            temp = (prevWord.grNum == gNum.plural.rawValue) ? "are" : "is"
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ","
        }else if prevWord.type == wordType.pronoun.rawValue {
            temp = "am"
        }else if prevWord.type == wordType.modal.rawValue {
            temp = "the"
        }
        return temp
    }
    func isVerb(prevWord: SelectedImageViewCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
            temp = "" // Exception?
        }else if prevWord.type == wordType.noun.rawValue {
            temp = (prevWord.grNum == gNum.plural.rawValue) ? "are" : "is"
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ""
        }else if prevWord.type == wordType.pronoun.rawValue {
            temp = "am"
        }else if prevWord.type == wordType.modal.rawValue {
            temp = "to"
        }
        return temp
    }
}

