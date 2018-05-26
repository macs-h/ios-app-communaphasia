//
//  Utility.swift
//  CommunAphasia
//
//  This class acts as a 'helper' class containing regularly used utility functions.
//
//  Created by RedSQ on 24/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class Utility {
    /**
     * Setting up singleton instance of Utility.
     *
     * To call any utility function: `Utility.sharedInstance.(function_name)`
     */
    static let sharedInstance = Utility()
    
    var database: Connection! // Connection to database.
    
    // Fields for the database.
    let CELL_TABLE = Table("cellTable")
    let ID = Expression<Int>("id")
    let IMAGE_LINK = Expression<String>("imageLink")
    let KEYWORD = Expression<String>("keyword")
    let RELATIONSHIPS = Expression<String>("relationships")
    let TYPE = Expression<String>("type")
    
    
    /**
     * Init function which initialises the database, creating the cells required, and populating
     * the cells with entries/information.
     */
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("cellTable").appendingPathExtension("sqlite3")
            let db = try Connection(fileUrl.path)
            self.database = db
        } catch {
            print(error)
        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore == true {  // should be false --------------------------------------------
            print("first launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.setCells()
            self.populateCells()
        } else {
            print("not first launch")
        }
        
//        setCells()
//        populateCells()
    }
    
    // ----------------------------------------------------------------------------
    func utilTest () {
        print("util test")
        print(getDatabaseEntry("cat", "linear", ["1"]))
    }
    // ----------------------------------------------------------------------------

    /**
     * A sentence processing function which takes in a string and breaks it down into tokens
     * (by whitespaces) and returns them as an array of words.
     *
     *  - Parameters:
     *      - inputString:    a string to be broken down into separate words.
     *      - charSet:      indicates which ASCII character is used to separate the sentence into
     *                      words.
     *  - Returns:    a 1D array of words.
     */
    func getSentenceToWords(_ inputString: String) -> Array<String> {
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
     *      - word:         the word describing the entry.
     *      - type:         the type of image (e.g. noun, adjective, etc.).
     *      - image:        the `UIImage` element.
     *      - suggestions:  possible suggestions which are related to the word.
     */
    func getDatabaseEntry(_ word: String, _ typeOfSearch: String, _ exclusionList:Array<String>) ->
        (word: String, type: String, image: UIImage, suggestions: [String]){
            let word = "word"
            let type = "type"
            let image = UIImage(named: "cow")
            print("image", image)
            let suggestions = ["this", "is", "the", "suggestion"]
        
        // check if the file exists and read to string
        do {
            let fileExists = try fileURL?.checkResourceIsReachable()
            if fileExists! {
                print("URL:",fileURL!)
                fileText = try String(contentsOf: fileURL!, encoding: .utf8)
            } else {
                print("File does not exist, cannot populate database")
                return
            }
        } catch {
            print(error.localizedDescription)
        }
        //populate database
        if fileText != "" {
            let lines = fileText.components(separatedBy: .newlines)
            for line in lines {
                //print("line:",line)
                var values = line.components(separatedBy: .init(charactersIn: ","))
                //print("v1: \(values[0])","v2: \(values[1])", "v3: \(values[2])")
                if values[0] != "" {
                    let insertImage = self.CELL_TABLE.insert(
                        self.KEYWORD <- values[0],
                        self.IMAGE_LINK <- values[1],
                        self.TYPE <- values[2],
                        self.RELATIONSHIPS <- values[3])
                    do {
                        try self.database.run(insertImage)
                        print("Inserted [ \(values[0]) ]")
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
}
