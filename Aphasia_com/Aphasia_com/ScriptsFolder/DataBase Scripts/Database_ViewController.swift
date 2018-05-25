//
//  Database_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 18/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit
import SQLite

class Database_ViewController: UIViewController {
    
    var database: Connection!
    
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var keywordText: UITextField!
    
    let imageTable = Table("images")
    let id = Expression<Int>("id")
    let link = Expression<String>("link")
    let keyword = Expression<String>("keyword")
    let relationships = Expression<String>("relationships")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("images").appendingPathExtension("sqlite3")
            let db = try Connection(fileUrl.path)
            self.database = db
        } catch {
            print(error)
        }
        
        //CREATE TABLE
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore == false {
            print("first launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            createTable()
            populateTable()
            //testFileManager()
            
        }else{
            print("not first launch")
        }
    }
/**
 *
 *
 */
    func createTable(){
        let makeTable = self.imageTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.link)
            table.column(self.keyword)
            table.column(self.relationships)
        }
        do {
            try self.database.run(makeTable)
            print("Table created")
        }catch{
            print(error)
        }
    }
    func populateTable(){
        var fileText = ""
        
        let fileURL = Bundle.main.url(forResource: "images", withExtension: "txt")
            
            //read to string
        do {
            let fileExists = try fileURL?.checkResourceIsReachable()
            if fileExists! {
                print("URL:",fileURL!)
                fileText = try String(contentsOf: fileURL!, encoding: .utf8)
            } else {
                print("File does not exist, create it")
            }
        } catch {
            print(error.localizedDescription)
        }
        if fileText != "" {
            let lines = fileText.components(separatedBy: .newlines)
            for line in lines {
                //print("line:",line)
                var values = line.components(separatedBy: .init(charactersIn: ","))
                //print("v1: \(values[0])","v2: \(values[1])", "v3: \(values[2])")
                if values[0] != "EOF" {
                    let insertImage = self.imageTable.insert(self.keyword <- values[0], self.link <- values[1],self.relationships <- values[2])
                    do {
                        try self.database.run(insertImage)
                        print("Inserted \(values[0])")
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    //testing file read, not actually being used
    func testFileManager () {
        let fileURL = Bundle.main.url(forResource: "images", withExtension: "txt")
        //this if statement is possibly unnecessary
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            //this does not find the file
            //let fileURL = documentsDirectory.appendingPathComponent("images.txt")
            do {
                let fileExists = try fileURL?.checkResourceIsReachable()
                if fileExists! {
                    print("File exists")
                    print(fileURL!)
                    let fileText = try String(contentsOf: fileURL!, encoding: .utf8)
                    print(fileText)
                } else {
                    print("File does not exist, create it")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    //not using this
    func searchTable(querry: String) -> String {
        var querryStatement: OpaquePointer? = nil
        //if sqlite3_prepare(self.database, querry, -1, &querryStatement, nil) == SQLITE_OK
        
        return ""
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        do{
            let images = try self.database.prepare(self.imageTable)  // gets entry out of DB.
            
            for image in images {
                if keywordText.text == image[self.keyword]{
                    imageView1.image = UIImage(named: image[self.link])
                }
            }
            self.view.window?.endEditing(true)
        }catch{
            print(error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
