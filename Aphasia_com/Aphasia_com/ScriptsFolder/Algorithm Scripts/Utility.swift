//
//  Utility.swift
//  CommunAphasia
//
//  Created by RedSQ on 24/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import Foundation
import UIKit
import SQLite

/// This class acts as a 'helper' class containing regularly used utility functions.
///
/// It has been set up in such a way that it is a singleton and available to be called
/// from any class within the project.
class Utility {

    /// Setting up singleton instance of Utility.
    /// To call any utility function: `Utility.sharedInstance.(function_name)`
    static let instance = Utility()
    
    // Connection to database.
    var database: Connection!
    
    //recently used image sentences
    var recentImageSentences : Array<[SelectedImageViewCell]> = []

    
    // Global exclusion list - words to ignore.
    let EXCLUSION_LIST: Array<String> = ["the","is","to","a","","am","."]
    
    // Fields for the database.
    let CELL_TABLE = Table("cellTable")
    let ID = Expression<Int>("id")
    let IMAGE_LINK = Expression<String>("imageLink")
    let KEYWORD = Expression<String>("keyword")
    let RELATIONSHIPS = Expression<String>("relationships")
    let TYPE = Expression<String>("type")
    let GR_NUM = Expression<String>("grNum")
    
    
    /// `Init` function which initialises the database, creating the cells required, and
    /// populating the cells with entries/information.
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
        if launchedBefore == false {  // should be false, set to true for TESTING -------------------
            print("> first launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.setCells()
            self.populateCells()
        } else {
            print("> not first launch")
        }
    }


    /**
     * A sentence processing function which takes in a string of words, breaks it down
     * into separate words (tokens) by whitespaces and places them into an array. It then
     * converts all the strings to lowercase, drops/removes from the array any words that
     * are present in the `EXCLUSION_LIST`, before returning the array of words.
     *
     *  - Parameters:
     *      - inputString:  a string to be broken down into separate words.
     *      - charSet:      indicates which ASCII character is used to separate the
     *                      sentence into words.
     *  - Returns:  a 1D array of words.
     */
    func getSentenceToWords(_ inputString: String, _ charSet: CharacterSet) -> Array<String> {
        return dropWords( (inputString.components(separatedBy: charSet)).map { $0.lowercased() }, EXCLUSION_LIST )
    }
    

    /**
     * Finds the entry in the database which corresponds to `word` and returns that entry
     * as a tuple containing the relevant metadata. It will search the database based on
     * the `typeOfSearch` parsed in.
     *
     *  - Parameters:
     *      - word:             the keyword to search for, in the database.
     *
     *  - Returns: a tuple which contains the information extracted from the database.
     *      - word:         the word describing the entry.
     *      - type:         the type of image (e.g. noun, adjective, etc.).
     *      - image:        the `UIImage` element.
     *      - suggestions:  possible suggestions which are related to the word.
     */
    func getDatabaseEntry(_ word: String) -> (word: String, type: String, image: UIImage, suggestions: [String], grNum: String) {
            var image: UIImage = UIImage(named: "image placeholder")!
            var word_type: String = ""
            var suggestions: Array<String> = []
            var grNum: String = gNum.singlular.rawValue  // Singular, by default.
        
            do {
                let cellTable = try self.database.prepare(self.CELL_TABLE)  // gets entry out of DB.
                for cell in cellTable {
                    if word == cell[self.KEYWORD] {
                        word_type = cell[self.TYPE]
                        image = UIImage(named: cell[self.IMAGE_LINK])!
                        suggestions = getSentenceToWords(cell[self.RELATIONSHIPS], .init(charactersIn: "+"))
                        //print("> found word:",word)
                        grNum = cell[self.GR_NUM]
                        break
                    }
                }
            } catch {
                print(error)
            }
            // Should we use enums as what is returned for the word_type??
            return (word, word_type, image, suggestions, grNum)
    }
    
    
    /**
     * Removes all the words in the exclusion list from the parsed in array.
     *
     *  - Parameters:
     *      - wordArray:        array containing the processed words from the original
     *                          sentence.
     *      - exclusionList:    array containing all the word(s) to be excluded.
     *
     *  - Returns:  an array of words, without the excluded word(s).
     */
    func dropWords(_ wordArray: Array<String>, _ exclusionList: Array<String>) -> Array<String> {
        return wordArray.filter { !exclusionList.contains($0) }
    }
    
    func setRecentImages(Sentence : [SelectedImageViewCell]){
        recentImageSentences.append(Sentence)
    }
    func printRecentImageSearches(){
        for sentence in recentImageSentences{
            for image in sentence{
                print(image.word + " ", terminator: "")
            }
            print("")
        }
    }
    
    // ----------------------------------------------------------------------------
    // Private functions follow.
    // ----------------------------------------------------------------------------
    
    /// Creates the cells in the database table. Only called from `init()`.
    private func setCells() {
        let makeTable = self.CELL_TABLE.create { (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.IMAGE_LINK)
            table.column(self.KEYWORD)
            table.column(self.TYPE)
            table.column(self.RELATIONSHIPS)
            table.column(self.GR_NUM)
        }
        do {
            try self.database.run(makeTable)
            print("> Table created")
        }catch{
            print(error)
        }
    }
    
    
    /// Populates the cells in the database table with data read in from a CSV text
    /// file.
    private func populateCells() {
        var fileText:String = ""
        let fileURL = Bundle.main.url(forResource: "images", withExtension: "txt")
        //print("file url", fileURL)
        // check if the file exists and read to string
        do {
            let fileExists = try fileURL?.checkResourceIsReachable()
            if fileExists != nil {
                fileText = try String(contentsOf: fileURL!, encoding: .utf8)
            } else {
                print("> File does not exist, cannot populate database")
                return
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Populates database
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
                        self.RELATIONSHIPS <- values[3],
                        self.GR_NUM <- values[4]
                    )
                    do {
                        try self.database.run(insertImage)
                        //print("> Inserted: \(values[0])")
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
}//end Utility


/// Used to colourise specific text in a UILabel.
extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}
