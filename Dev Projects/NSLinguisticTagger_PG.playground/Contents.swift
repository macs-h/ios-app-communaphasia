//: Playground - noun: a place where people can play

import Cocoa

var inputString = "Some input text"
//noVerb = true
//noPronoun = true
var i = 0
var outputArray: [String] = []

let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
tagger.string = inputString
let range = NSRange(location: 0, length: inputString.utf16.count)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
print("start")
tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
    if let tag = tag {
        let word = (inputString as NSString).substring(with: tokenRange)
//        inputArray.append(word)
        print("> Word:", word)
        print("> Tagged as:", tag.rawValue)
        
    }
    
}
