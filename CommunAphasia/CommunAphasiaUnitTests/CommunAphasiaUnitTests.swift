//
//  CommunAphasiaUnitTests.swift
//  CommunAphasiaUnitTests
//
//  Created by RedSQ on 28/09/18.
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
    
    func testImageInputViewControllerDoesNotCrash() {
        print("--- START testImageInputViewControllerDoesNotCrash() ---\n")
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageInputVC") as! ImageInput_ViewController
        vc.loadView()
        
        
        print("\n--- END testImageInputViewControllerDoesNotCrash() ---")
    }
    
    
    func testTextInputViewControllerDoesNotCrash() {
        print("--- START testTextInputViewControllerDoesNotCrash() ---\n")
        
        func randomString(strLength: Int) -> String {
            let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'"
//            let specialChar: NSString = "-/–:;()$&@\".,?!'[]{}#%^*+=_\\|~<>£º•"
            
//            letters.append(specialChar as String)
//            print("-- Letters:\n", letters)
            
            let len = UInt32(letters.length)
            var randomString = ""
            
            for _ in 0 ..< strLength {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            return randomString
        }
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextInputVC") as! TextInput_ViewController
        vc.loadView()
        
        // ----------------------------------

//        let testString: String = "mO7£ }7 ECP^ \'- !–[ (;OB; Kb=,£wSs"
////        let testString: String = "Trees don't like to feel"
//
//        vc.textField.text = testString
//        print(">>>", vc.textField.text!)
//
//        vc.done(self)


//        // ----------------------------------
        
        
        // Test 100 sentences
        for _ in 0..<100 {
            var testString: String = ""

            let upper: Int = Int(arc4random_uniform(9))
            for _ in 0...upper {
                testString += randomString(strLength: Int(arc4random_uniform(9))+1)
                testString += " "
            }

            vc.textField.text = testString
            print(">>>", vc.textField.text!)

            vc.done(self)
        }
        
        print("\n--- END testTextInputViewControllerDoesNotCrash() ---")
    }
    
    
    
}
