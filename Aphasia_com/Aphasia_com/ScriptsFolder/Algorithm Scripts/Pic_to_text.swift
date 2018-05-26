//
//  Pic_to_text.swift
//  Aphasia_com
//
//  Created by Winston Downes 24/05/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import Foundation

func imageToText(cellList:[SelectViewCell]){
    var returnString:[String]
    
    if cellList[0].type == noun {
        returnString[0] = "The"
        returnString[1] = list[0].keyword
    }
    
    if cellList[1].type == adj {
        if cellList[0].num == 1 {
            returnString[2] = "is"
        }
        if cellList[0].num == 2 {
            returnString[2] = "are"
        }
        returnString[3] = cellList[1].keyword
    }
    if cellList[1].type == noun {
        if cellList[0].num == 1 {
            returnString[3] = "is"
        }
        if cellList[0].num == 2 {
            returnString[3] = "are"
        }
        returnString[2] = cellList[1].keyword
    }
    if cellList[1].type == verb {
        if cellList[0].num == 1 {
            returnString[3] = "is"
        }
        if cellList[0].num == 2 {
            returnString[3] = "are"
        }
        returnString[2] = cellList[1].keyword
    }
}

