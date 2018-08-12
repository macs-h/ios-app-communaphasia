//
//  main.swift
//  Lemmatize_Testing
//
//  Created by Max Huang on 10/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation

func lemmaTag(inputString: String) -> [String] {
    var returnArray:[String] = []
    let tagger = NSLinguisticTagger(tagSchemes: [.lemma], options: 0)
    tagger.string = inputString
    tagger.enumerateTags(in: NSRange(location: 0, length: inputString.utf16.count),
                         unit: .word,
                         scheme: .lemma,
                         options: [.omitPunctuation, .omitWhitespace])
    { tag, tokenRange, _ in
        if let tag = tag {
            let word = (inputString as NSString).substring(with: tokenRange)
            returnArray.append(tag.rawValue)
            print("\(word): \(tag.rawValue)")
        }
    }
    return returnArray
}


print(lemmaTag(inputString: "the dog ate the cow"))
