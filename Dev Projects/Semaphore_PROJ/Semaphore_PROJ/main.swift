//
//  main.swift
//  Semaphore_PROJ
//
//  Created by Max Huang on 11/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation

func getBoolValue(number : Int, completion: (_ result: Bool)->()) {
    if number > 5 {
        completion(true)
    } else {
        completion(false)
    }
}

getBoolValue(number: 8) { (result) -> () in
    // do stuff with the result
    print(result)
}
