//
//  Utility.swift
//  Aphasia_com
//
//  Created by Max Huang on 24/05/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import Foundation
import UIKit

/**
 * This class acts as a 'helper' class containing regularly used utility functions.
 * All function names in this class being with `get` for sake of consistency.
 */
class Utility {

    /**
     * A sentence processing function which takes in a string and breaks it down into tokens
     * (by whitespaces) and returns them as an array of words.
     *  - Parameter inputString:	a string to be broken down into separate words.
     *  - Returns:	a 1D array of words.
     */
    static func getSentenceToWords(_ inputString: String) -> Array<String> {
        return inputString.components(separatedBy: .whitespaces)
        
    }


    /**
     * Finds the entry in the database which corresponds to `word` and returns that entry as a tuple
     * containing the relevant metadata. It will search the database based on the `typeOfSearch`
     * parsed in.
     *
     *  - Parameters:
     *      - word:             the keyword to search for, in the database.
     *      - typeOfSearch:     the type of search to use (`simple` / `linear` / `binary`)
     *      - exclusionList:    the list containing all the words NOT to be searched for.
     *
     *  - Returns: a tuple which contains the information extracted from the database.
     */
    static func getDatabaseEntry(_ word: String, _ typeOfSearch: String, _ exclusionList:Array<String>) ->
        (word: String, type: String, image: UIImage, suggestions: [String]){
            let word = "word"
            let type = "type"
            let image = UIImage(named: "placeholder.png")
            let suggestions = ["this", "is", "the", "suggestion"]
        
            return (word, type, image!, suggestions)
    }
}
