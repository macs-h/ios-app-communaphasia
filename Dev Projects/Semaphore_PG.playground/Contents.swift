//: Playground - noun: a place where people can play

import UIKit

let handler: ([String]) -> Void = { (array) in
    print("Done working, \(array)")
}


func workSuperHard(doneStuffBlock: ([String]) -> Void) {
    for _ in 1...2 {
        print("But you gotta put in 🔨, 🔨, 🔨")
    }
    doneStuffBlock(["Blog", "Course", "Editing", "Helping"])
}


workSuperHard(doneStuffBlock: handler)
print("")
workSuperHard { (workList) in
    print("I've done \(workList[0]). Let me go!")
}



//func getBoolValue(number : Int, completion: (_ result: Bool)->()) {
//    if number > 5 {
//        completion(true)
//    } else {
//        completion(false)
//    }
//}
//
//getBoolValue(number: 8) { (result) -> () in
//    // do stuff with the result
//    print(result)
//}
