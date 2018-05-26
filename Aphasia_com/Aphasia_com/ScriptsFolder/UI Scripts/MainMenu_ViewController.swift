//
//  MainMenu_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit
import SQLite

class MainMenu_ViewController: UIViewController {
//    var database: Connection!
//    let UTILITY = Utility()
//
//    let imageTable = Table("images")
//    let id = Expression<Int>("id")
//    let link = Expression<String>("link")
//    let keyword = Expression<String>("keyword")
//    let relationships = Expression<String>("relationships")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initilaises the databases.
//        UTILITY.initialise()
        
        // Do any additional setup after loading the view.
//        do {
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("images").appendingPathExtension("sqlite3")
//            let db = try Connection(fileUrl.path)
//            self.database = db
//        } catch {
//            print(error)
//        }
//
//        //CREATE TABLE
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        if launchedBefore == false {
//            print("first launch")
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
//            createTable()
//            populateTable()
//            //testFileManager()
//
//        }else{
//            print("not first launch")
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func createTable(){
//        let makeTable = self.imageTable.create { (table) in
//            table.column(self.id, primaryKey: true)
//            table.column(self.link)
//            table.column(self.keyword)
//            table.column(self.relationships)
//        }
//        do {
//            try self.database.run(makeTable)
//            print("Table created")
//        }catch{
//            print(error)
//        }
//    }
    
    
//    func populateTable(){
//        var fileText = ""
//
//        let fileURL = Bundle.main.url(forResource: "images", withExtension: "txt")
//
//        //read to string
//        do {
//            let fileExists = try fileURL?.checkResourceIsReachable()
//            if fileExists != nil  {
//                print("URL:",fileURL!)
//                fileText = try String(contentsOf: fileURL!, encoding: .utf8)
//            } else {
//                print("File does not exist, create it")
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//        if fileText != "" {
//            let lines = fileText.components(separatedBy: .newlines)
//            for line in lines {
//                //print("line:",line)
//                var values = line.components(separatedBy: .init(charactersIn: ","))
//                //print("v1: \(values[0])","v2: \(values[1])", "v3: \(values[2])")
//                if values[0] != "EOF" {
//                    let insertImage = self.imageTable.insert(self.keyword <- values[0], self.link <- values[1],self.relationships <- values[2])
//                    do {
//                        try self.database.run(insertImage)
//                        print("Inserted \(values[0])")
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }


}
