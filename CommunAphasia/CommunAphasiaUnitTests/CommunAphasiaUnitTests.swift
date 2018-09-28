//
//  CommunAphasiaUnitTests.swift
//  CommunAphasiaUnitTests
//
//  Created by Max Huang on 28/09/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import XCTest
import Foundation
@testable import CommunAphasia

class CommunAphasiaUnitTests: XCTestCase {
    
    // Set up database
    let util = Utility.instance
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTextInputViewControllerDoesNotCrash() {
        print("--- START testTextInputViewControllerDoesNotCrash() ---\n")
        
        func randomString(length: Int) -> String {
            let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'"
//            let specialChar: NSString = "-/–:;()$&@\".,?!'[]{}#%^*+=_\\|~<>£º•"
            
        
            let len = UInt32(letters.length)
            var randomString = ""
            
            for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            return randomString
        }

        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextInputVC") as! TextInput_ViewController
        vc.loadView()
        
        for _ in 0...15 {
            
            var testString: String = ""

            let upper: Int = Int(arc4random_uniform(9))
            for _ in 0...upper {
                testString += randomString(length: Int(arc4random_uniform(9))+1)
                testString += " "
            }
            
            vc.textField.text = testString
            print(">>>", vc.textField.text!)
            
            vc.done(self)
        }
        
        
        print(randomString(length: 5))


        
        
        print("\n--- END testTextInputViewControllerDoesNotCrash() ---")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
