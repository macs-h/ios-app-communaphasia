//
//  ImageToText.swift
//  CommunAphasia
//
//  Created by RedSQ 24/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit
import Foundation

var haveSubject: Bool = false
var subVerb: Bool = false

class ImageToText {
    static let instance = ImageToText()
    var cell: ImageCell?
    var tenses: [String] = []

    private init(){
    }

    func createSentence(pics: [ImageCell]) -> String {
        var returnString:Array<String> = []
        var temp:String = ""
        var wordToAppend = ""
        let dict = ["past":0,"present":1,"future":2]
        
        for imageNum in 0...pics.count-1 {
            tenses = pics[imageNum].tense.components(separatedBy: "+")
            //first word, probably add 'the'
            if imageNum==0 {
                if (pics[0].type == wordType.adjective.rawValue || pics[0].type == wordType.noun.rawValue){
                    returnString.append("The")          // index 0
                    haveSubject = true
                    if pics[0].type == wordType.noun.rawValue {
                        returnString.append((pics[0].grNum != "singular") ? pluralize(pic: pics[0]) : pics[0].word)   // index 1
                    }
                } else if pics[0].type == wordType.pronoun.rawValue {
                    haveSubject = true
                    returnString.append(pics[0].word)
                    
                } else {
                    returnString.append(tenses[dict[pics[0].tenseType]!])
                }
            }else{
                let thisPic = pics[imageNum]  // only need to access value once, instead of thrice.
                let prevPic = pics[imageNum-1]
                
                if thisPic.type == wordType.noun.rawValue {
                    temp = isNoun(prevWord: prevPic)
                    wordToAppend = (thisPic.grNum == "singular") ? thisPic.word : pluralize(pic: thisPic)
                    returnString.append(temp)
                    returnString.append(wordToAppend)
                }else if thisPic.type == wordType.pronoun.rawValue {
                    if haveSubject == true {
                        returnString.append(thisPic.grNum)
                    }
                }else if thisPic.type == wordType.modal.rawValue {
                    temp = isModal(prevWord: prevPic, currentWord: thisPic)
                    returnString.append(temp)
                    returnString.append(tenses[dict[thisPic.tenseType]!])
                    subVerb = true
                }else if thisPic.type == wordType.adverb.rawValue {
                    temp = isAdverb(prevWord: prevPic)
                    returnString.append(temp)
                    returnString.append(thisPic.word)
                }else if thisPic.type == wordType.adjective.rawValue {
                    temp = isAdj(prevWord: prevPic, currentWord: thisPic)
                    returnString.append(temp)
                    returnString.append(thisPic.word)
                }else if thisPic.type == wordType.verb.rawValue {
                    temp = isVerb(prevWord: prevPic, currentWord: thisPic)
                    returnString.append(temp)
                    if prevPic.type == wordType.modal.rawValue && prevPic.tenseType == "past" {
                        returnString.append(tenses[0])
                    }
                    else if subVerb == true {
                    returnString.append(thisPic.word)
                    } else {
                    returnString.append(tenses[dict[thisPic.tenseType]!])
                    }
                    subVerb = true
                }else{
                    returnString.append(thisPic.word)
                }
            }
        }
        return returnString.joined(separator: " ")
    }
    
    func pluralize(pic: ImageCell) -> String {
        if (pic.grNum == "plural") {
            return pic.word + "s"
        } else {
            return pic.grNum
        }
    }
    
    func isNoun(prevWord: ImageCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
            if prevWord.suggestedWords[0] != "nil" {
            temp = prevWord.suggestedWords[0] + " the"
            } else {
                temp = "the"
            }
        }else if prevWord.type == wordType.noun.rawValue {
            temp = (prevWord.grNum == "singular") ? "is" : "are"
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ""
        }else if prevWord.type == wordType.pronoun.rawValue {
            temp = "the"
        }else if prevWord.type == wordType.modal.rawValue {
            temp = "the"
        }else if prevWord.type == wordType.adverb.rawValue {
            temp = ""
        }
        return temp
    }
    
    func isAdj(prevWord: ImageCell, currentWord: ImageCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
            if prevWord.suggestedWords[0] != "nil" {
                temp = prevWord.suggestedWords[0] + " the"
            } else {
            temp = "the"
            }
        }else if prevWord.type == wordType.noun.rawValue {
            temp = (prevWord.grNum == "singular") ? "is" : "are"
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ","
        }else if prevWord.type == wordType.pronoun.rawValue {
            if currentWord.tenseType == "past" {
                temp = prevWord.suggestedWords[0]
            } else if currentWord.tenseType == "present" {
                temp = prevWord.suggestedWords[1]
            } else {
                temp = prevWord.suggestedWords[2]
            }
        }else if prevWord.type == wordType.modal.rawValue {
            temp = "the"
        }else if prevWord.type == wordType.adverb.rawValue {
            temp = ""
        }
        return temp
    }
    func isAdverb(prevWord: ImageCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
        }else if prevWord.type == wordType.noun.rawValue {
            temp = (prevWord.grNum == "singular") ? "is" : "are"
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ","
        }else if prevWord.type == wordType.pronoun.rawValue {
            temp = ""
        }else if prevWord.type == wordType.modal.rawValue {
            temp = "the"
        }else if prevWord.type == wordType.adverb.rawValue {
            temp = ","
        }
        return temp
    }
    func isVerb(prevWord: ImageCell, currentWord: ImageCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
            if subVerb == true {
                temp = "to"
            }
        }else if prevWord.type == wordType.noun.rawValue {
            if haveSubject == true {
                temp = "to"
            } else {
            temp = (prevWord.grNum == "singular") ? "is" : "are"
            }
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ""
        }else if prevWord.type == wordType.pronoun.rawValue {
            if currentWord.tenseType == "present" {
            temp = prevWord.suggestedWords[0]
            }
        }else if prevWord.type == wordType.modal.rawValue {
            temp = ""
        }else if prevWord.type == wordType.adverb.rawValue {
            temp = ""
        }
        return temp
    }
    func isModal(prevWord: ImageCell, currentWord: ImageCell) -> String{
        var temp = ""
        if prevWord.type == wordType.verb.rawValue {
            temp = ""
        }else if prevWord.type == wordType.noun.rawValue {
            temp = ""
        }else if prevWord.type == wordType.adjective.rawValue {
            temp = ""
        }else if prevWord.type == wordType.pronoun.rawValue {
            temp = ""
        }else if prevWord.type == wordType.modal.rawValue {
            temp = ""
        }else if prevWord.type == wordType.adverb.rawValue {
            temp = ""
        }
        return temp
    }
    
    public func reset() {
        haveSubject = false
        subVerb = false
    }
}

