//: Playground - noun: a place where people can play

import Cocoa

let array = "The dog ate the cat"

//func lemmatize(_ word: [String]) -> String {
//    var returnString:String = ""
//    let tagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)
//    tagger.string = word
//
//    tagger.enumerateTags(in: NSMakeRange(0, word.utf16.count),
//                         unit: .word,
//                         scheme: .lemma,
//                         options: [.omitWhitespace, .omitPunctuation])
//    { (tag, tokenRange, stop) in
//
//        if let lemma = tag?.rawValue {
//            returnString = lemma
//        } else {
//            returnString = word
//        }
//
//    }
//    return returnString
//}

let inputString = "he ate me"


let tagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)
tagger.string = inputString
tagger.enumerateTags(in: NSRange(location: 0, length: inputString.utf16.count),
                     unit: .word,
                     scheme: .lemma,
                     options: [.omitPunctuation, .omitWhitespace])
{ tag, tokenRange, _ in
    if let tag = tag {
        let word = (inputString as NSString).substring(with: tokenRange)
        
        print("\(word): \(tag.rawValue)")
        
        
    }
    
}
