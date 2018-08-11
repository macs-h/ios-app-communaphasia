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

/**
    This class acts as a 'helper' class containing regularly used utility functions.

    It has been set up in such a way that it is a singleton and available to be called
    from any class within the project.
 */
class Utility {

    // Setting up singleton instance of Utility.
    // To call any utility function: `Utility.sharedInstance.(function_name)`
    static let instance = Utility()
    // Connection to database.
    var database: Connection!
    //recently used image sentences
    var recentSentences : Array<[ImageCell]> = []
    // Global exclusion list - words to ignore.
    let EXCLUSION_LIST: Array<String> = ["the","is","to","a","","am","."]
    //commonly used images to be displayed in the common category
    let commonImages = ["i","eating"]
    //the categories our images may represent
    let categories = ["emotions","animals","food","activity","travel","objects","other"]
    
    // Fields for the database.
    let CELL_TABLE = Table("cellTable")
    let ID = Expression<Int>("id")
    let IMAGE_LINK = Expression<String>("imageLink")
    let KEYWORD = Expression<String>("keyword")
    let RELATIONSHIPS = Expression<String>("relationships")
    let TYPE = Expression<String>("type")
    let GR_NUM = Expression<String>("grNum")
    let CATEGORY = Expression<String>("category")
    let TENSE = Expression<String>("tense")
    
    
    // `Init` function which initialises the database, creating the cells required, and
    // populating the cells with entries/information.
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
    func getSentenceToWords(from inputString: String, separatedBy charSet: CharacterSet, removeSelectWords:Bool? = true) -> Array<String> {
        if removeSelectWords! {
            return dropWords( (inputString.components(separatedBy: charSet)).map { $0.lowercased() }, EXCLUSION_LIST )
        } else {
            return (inputString.components(separatedBy: charSet))
        }
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
    
    func setRecentSentence(Sentence : [ImageCell]){
        recentSentences.append(Sentence)
    }
    func printRecentSentences(){
        for sentence in recentSentences{
            for image in sentence{
                print(image.word + " ", terminator: "")
            }
            print("")
        }
    }
    //---------------------------
    //------Database Stuff-------
    //---------------------------
    /**
     * Finds the entry in the database which corresponds to `word` and returns that entry
     * as a tuple containing the relevant metadata.
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
    func getDatabaseEntry(_ word: String) -> (word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String, tense: String){
        var image: UIImage = UIImage(named: "image placeholder")!
        var word_type: String = ""
        var suggestions: Array<String> = []
        var grNum: String = gNum.singlular.rawValue  // Singular, by default.
        var category: String = "Other"
        var tense: String = ""
        
        do {
            let querry = CELL_TABLE.select(KEYWORD,TYPE,IMAGE_LINK,RELATIONSHIPS,GR_NUM,CATEGORY,TENSE).filter(KEYWORD.like(word)).limit(1)
            for cell in try database.prepare(querry){
                word_type = cell[TYPE]
                image = UIImage(named: cell[IMAGE_LINK])!
                suggestions = getSentenceToWords(from: cell[RELATIONSHIPS], separatedBy: .init(charactersIn: "+"))
                grNum = cell[GR_NUM]
                category = cell[CATEGORY]
                tense = cell[TENSE]
                
            }
        } catch {
            print(error)
        }
        return (word, word_type, image, suggestions, grNum, category, tense)
    }
    
    func checkWordsInDatabase(words: [String]) -> [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String, tense: String)]{
        //let lowerWords = words.map {$0.lowercased()}
        var cells = [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String)]()
        let querry = CELL_TABLE.select(KEYWORD,TYPE,IMAGE_LINK,RELATIONSHIPS,GR_NUM,CATEGORY,TENSE).filter(words.contains(KEYWORD))
        
        do{
            for cell in try database.prepare(querry){
                cells.append((cell[KEYWORD],
                              cell[TYPE],
                              UIImage(named: cell[self.IMAGE_LINK])!,
                              getSentenceToWords(from: cell[self.RELATIONSHIPS], separatedBy: .init(charactersIn: "+")),
                              cell[GR_NUM],
                              cell[CATEGORY],
                              cell[TENSE]))
            }
        } catch {
            print(error)
        }
        return cells
    }

    
    func getCellsByCategory(category: String) -> [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String)] {
        var cells = [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String)]()
        let querry = CELL_TABLE.select(KEYWORD,TYPE,IMAGE_LINK,RELATIONSHIPS,GR_NUM,CATEGORY,TENSE).filter(CATEGORY.like(category))
        do{
            for cell in try database.prepare(querry){
                cells.append((cell[KEYWORD],
                              cell[TYPE],
                              UIImage(named: cell[self.IMAGE_LINK])!,
                              getSentenceToWords(from: cell[self.RELATIONSHIPS], separatedBy: .init(charactersIn: "+")),
                              cell[GR_NUM],
                              cell[CATEGORY],
                              cell[TENSE]))
            }
        } catch {
            print(error)
        }
        return cells
    }
    
    
    // ----------------------------------------------------------------------------
    // Lemmatization
    // ----------------------------------------------------------------------------
    
    
    @available(iOS 11.0, *)
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
    
    
    
    // ----------------------------------------------------------------------------
    // API for synonyms via WordsAPI
    // ----------------------------------------------------------------------------
    private class MyDelegate: NSObject, URLSessionDataDelegate {
        fileprivate var synonyms: [String] = []
        fileprivate func urlSession(_ session: URLSession,
                                        dataTask: URLSessionDataTask,
                                        didReceive data: Data) {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Any],
                let syn = dictionary["synonyms"] {
                self.synonyms = ((syn as! NSArray).componentsJoined(by: ",")).components(separatedBy: ",")
            }
        }
    }
    
    func getSynonym(_ word: String) -> [String] {
        let baseUrl = "https://wordsapiv1.p.mashape.com/words/"
        let type = "synonyms"
        let url = NSURL(string: baseUrl + word + "/" + type)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("yTv8TIqHmimshZvfKLil4h6A2zT2p11GQe5jsnr4XhZtyt69bm", forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "X-Mashape-Host")
        request.httpMethod = "GET"
        
        let delegateObj = MyDelegate()
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: delegateObj,
                                 delegateQueue: nil)
        let task = session.dataTask(with: request as URLRequest)
        task.resume()
        sleep(2)
        return delegateObj.synonyms
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
            table.column(self.CATEGORY)
            table.column(self.TENSE)
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
        //finds the txt file which we use to populate the database
        var fileText:String = ""
        let fileURL = Bundle.main.url(forResource: "images", withExtension: "txt")
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
                var values = line.components(separatedBy: .init(charactersIn: ","))
                if values[0] != "" {
                    let insertImage = self.CELL_TABLE.insert(
                        self.KEYWORD <- values[0],
                        self.IMAGE_LINK <- values[1],
                        self.TYPE <- values[2],
                        self.RELATIONSHIPS <- values[3],
                        self.GR_NUM <- values[4],
                        self.CATEGORY <- values[5],
                        self.TENSE <- values[6]
                    )
                    do {
                        try self.database.run(insertImage)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    
    
}//end Utility class


/// Used to colourise specific text in a UILabel.
extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
