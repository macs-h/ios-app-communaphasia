//
//  main.swift
//  NSLinguisticTagger_Proj
//
//  Created by Max Huang on 9/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation

//func lemmatize(_ word: String) -> String {
//    var returnString:String = ""
//    let tagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)
//    tagger.string = word
//    let range = NSMakeRange(0, word.utf16.count)
//    let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation]
//
//    tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { (tag, tokenRange, stop) in
//        if let lemma = tag?.rawValue {
//            returnString = lemma
//        } else {
//            returnString = word
//        }
//    }
//    return returnString
//}
//
//print(lemmatize("eating"))


let input = "This is some text"

func getSentenceToWords(_ inputString: String, _ charSet: CharacterSet) -> Array<String> {
    return (inputString.components(separatedBy: charSet))
}

print(getSentenceToWords(input, .whitespaces))
