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
import SystemConfiguration

/**
    This class acts as a 'helper' class containing regularly used utility
    functions.

    It has been set up in such a way that it is a singleton and available to be
    called from any class within the project.
 */
class Utility {
    
    // Setting up the singleton instance of Utility.
    // To call any utility function: `Utility.sharedInstance.(function_name)`
    static let instance = Utility()
    
    // Connection to database.
    var database: Connection!
    
    // Array holding recently used image sentences.
    var recentSentences : Array<[ImageCell]> = []
    
    // Global exclusion list - words to ignore.
    let EXCLUSION_LIST: Array<String> = ["the","is","to","a","","am","."]
    
    // Commonly used images to be displayed in the `common` category.
    let commonImages = ["i","eating"]
    
    // The categories our images may represent.
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
    
    
    /**
        Initialisation function which initialises the database, creating the
        cells required, and populating the cells with entries/information.
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
        A sentence processing function which takes in a string of words, breaks
        it down into separate words (tokens) by whitespaces and places them
        into an array. It then converts all the strings to lowercase,
        drops/removes from the array any words that are present in the
        `EXCLUSION_LIST`, before returning the array of words.

        - Parameters:
           - inputString:  a string to be broken down into separate words.
           - charSet:      indicates which ASCII character is used to separate
                           the sentence into words.
        - Returns:  a 1D array of words.
     */
    func getSentenceToWords(from inputString: String, separatedBy charSet: CharacterSet, removeSelectWords:Bool? = true) -> Array<String> {
        if removeSelectWords! {
            return dropWords( (inputString.components(separatedBy: charSet)).map { $0.lowercased() }, EXCLUSION_LIST )
        } else {
            return (inputString.components(separatedBy: charSet))
        }
    }
    
    /**
        Removes all the words in the exclusion list from the parsed in array.

        - Parameters:
           - wordArray:        array containing the processed words from the
                               original sentence.
           - exclusionList:    array containing all the word(s) to be excluded.

        - Returns:  an array of words, without the excluded word(s).
     */
    func dropWords(_ wordArray: Array<String>, _ exclusionList: Array<String>) -> Array<String> {
        return wordArray.filter { !exclusionList.contains($0) }
    }
    
    
    /**
        Adds a sentence to the list of previously used sentences for the
        current session.
     */
    func setRecentSentence(Sentence : [ImageCell]){
        recentSentences.append(Sentence)
    }
    
    
    /**
        A debug function that prints the `recentSentences` to stdout.
     */
    func printRecentSentences(){
        for sentence in recentSentences{
            for image in sentence{
                print(image.word + " ", terminator: "")
            }
            print("")
        }
    }
    
    
    
    // ----------------------------------------------------------------------
    // Database functions.
    // ----------------------------------------------------------------------
    
    /**
        Finds the entry in the database which corresponds to `word` and returns
        that entry as a tuple containing the relevant metadata.

        - Parameter word:  the keyword to search for, in the database.

        - Returns:  a tuple which contains the information extracted from the
                    database.
           - word:         the word describing the entry.
           - type:         the type of image (e.g. noun, adjective, etc.).
           - image:        the `UIImage` element.
           - suggestions:  possible suggestions which are related to the word.
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
    
    
    /**
        Takes in an array of words, searches for them in the database and
        returns an array of `cells` for each valid word that matches a keyword
        in the database.
     
        - Parameter words:  an array of words holding the user's input.
     
        - Returns:  an array of `cells` which were retrieved from the database.
     */
    func getWordsInDatabase(words: [String]) -> [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String, tense: String)] {
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

    
    /**
        Checks if there is a matching database entry for the word.
     
        - Parameter word:   word to be checked for in the database.
     
        - Returns: `true` if word exists in database, else `false`.
     */
    func isInDatabase(word: String) -> Bool {
        do{
            let count = try database.scalar(CELL_TABLE.filter(KEYWORD.like(word)).count)
            if count > 0 {
                return true
            }
        }catch{
            print(error)
        }
        return false
    }
    
    
    /**
        Retrieves entries from the database as `cells` for all database entries
        that match the given category.
     
        - Parameter category:   the category to be searched for.
     
        - Returns:  an array of `cells` which matched the category.
     */
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
    
    
    
    // ----------------------------------------------------------------------
    // Lemmatization
    // ----------------------------------------------------------------------
    
    /**
        Uses NSLinguisticTagger to lemmatize (find the stem of) each given word,
        and returns the tags as an array.
     
        - Parameter inputString:    the words (as a string) to be lemmatized.
     
        - Returns:  an array holding the lemma of each input word.
     */
    @available(iOS 11.0, *)
    func lemmaTag(inputString: String) -> [String] {
        var returnArray:[String] = []
        var count: Int = 0
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
                count += 1
            } else {
                returnArray.append((inputString.components(separatedBy: " "))[count])
                count += 1
            }
        }
        return returnArray
    }


    
    // ----------------------------------------------------------------------
    // API for synonyms via WordsAPI
    // ----------------------------------------------------------------------
    
    /**
        A private delegate class used to process and hold `.json` data returned
        from a RESTful API request.
     */
    private class MyDelegate: NSObject, URLSessionDataDelegate {
        fileprivate var synonyms: [String] = []
        fileprivate func urlSession(_ session: URLSession,
                                        dataTask: URLSessionDataTask,
                                        didReceive data: Data) {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Any],
                let syn = dictionary["synonyms"] {
                self.synonyms = ((syn as! NSArray).componentsJoined(by: " ")).components(separatedBy: " ")
            }
        }
    }
    
    
    /**
        Makes a RESTful call to WordsAPI, using delegates, to retrieve
        synonyms which will be used as suggesetions for any invalid words the
        user gives as input.
     
        - Parameter word:   the word to find synonyms for.
     
        - Returns:  an array of synonymous words, else `nil`.
     */
    func getSynonym(_ word: String) -> [String]? {
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
        var timeOut = 0
        while (delegateObj.synonyms.isEmpty) {
            if timeOut >= 3000 {  // Timeout set to 3 seconds
                print("API timed out")
                return nil
            }
            usleep(20 * 1000)  // sleep for 20 milliseconds
            timeOut += 20
        }
        return delegateObj.synonyms
    }
    
    
    /**
        Filters out words that exist in our database.
     
        - Parameter inArray:    an array of words.
     
        - Returns:  an array which only contains words that exist in our
                    database, from `inArray`.
     */
    func synonymsInDataBase(from inArray: [String]) -> [String] {
        var returnArray: [String] = []
        for word in inArray {
            if isInDatabase(word: word) {
                returnArray.append(word)
            }
        }
        return returnArray
    }
    
    
    /**
        Checks if there is an internet connection.
     
        - Returns: `true` if connected to a network, otherwise `false`.
     */
    func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }

    
    // ----------------------------------------------------------------------
    // Private functions follow.
    // ----------------------------------------------------------------------
    
    /**
        Creates the cells in the database table. Only called from `init()`.
     */
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
    
    
    /**
        Populates the cells in the database table with data read in from a CSV
        text file.
     */
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
    
}
// End of Utility class!
// ----------------------------------------------------------------------


/**
    Used to colourise specific text in a UILabel.
 */
extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}


/**
    Used to turn a hex string into a UIColor.
 */
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
