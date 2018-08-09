//: Playground - noun: a place where people can play

import Cocoa


let input = "This is some text"

func getSentenceToWords(_ inputString: String, _ charSet: CharacterSet) -> Array<String> {
    return (inputString.components(separatedBy: charSet))
}

print(getSentenceToWords(input, .whitespaces))
