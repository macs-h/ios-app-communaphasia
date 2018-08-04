//
//  main.swift
//  tmp
//
//  Created by Max Huang on 4/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation

//print("Hello world")
//
//func makeGetCall() -> Int {
//    print("> In function")
//    // Set up the URL request
//    let todoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
//    guard let url = URL(string: todoEndpoint) else {
//        print("Error: cannot create URL")
//        return 1
//    }
//    let urlRequest = URLRequest(url: url)
//
//    // set up the session
//    let config = URLSessionConfiguration.default
//    let session = URLSession(configuration: config)
//
//    // make the request
//    let task = session.dataTask(with: urlRequest) {
//        (data, response, error) in
//        // check for any errors
//        guard error == nil else {
//            print("error calling GET on /todos/1")
//            print(error!)
//            return
//        }
//        // make sure we got data
//        guard let responseData = data else {
//            print("Error: did not receive data")
//            return
//        }
//
//        // parse the result as JSON, since that's what the API provides
//        do {
//            guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
//                as? [String: Any] else {
//                    print("error trying to convert data to JSON")
//                    return
//            }
//            // now we have the todo
//            // let's just print it to prove we can access it
//            print("The todo is: " + todo.description)
//
//            // the todo object is a dictionary
//            // so we just access the title using the "title" key
//            // so check for a title and print it if we have one
//            guard let todoTitle = todo["title"] as? String else {
//                print("Could not get todo title from JSON")
//                return
//            }
//            print("The title is: " + todoTitle)
//        } catch  {
//            print("error trying to convert data to JSON")
//            return
//        }
//    }
//    task.resume()
//    print(task)
//    return 2
//}
//
//print("return: ",makeGetCall())
//print("> Fin.")

func get() {
    let string = "https://wordsapiv1.p.mashape.com/words/stack/synonyms"
    let url = NSURL(string: string)
    let request = NSMutableURLRequest(url: url! as URL)
    request.setValue("yTv8TIqHmimshZvfKLil4h6A2zT2p11GQe5jsnr4XhZtyt69bm", forHTTPHeaderField: "X-Mashape-Key")
    request.setValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "X-Mashape-Host")
    request.httpMethod = "GET"
    let session = URLSession.shared

    let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
        if let resp = response as? HTTPURLResponse {
            print("> GOT RESPONSE:\n", response)
            print("RESP:", resp)
            // Do what you want to do with your response.
        }
    }
    print("> start: task")
    task.resume()
    print("> EO: get")
    print("> request headers:\n", request.allHTTPHeaderFields!)
    
//    print("> resp:\n", resp)
   
    
    
}

print("> start")
get()
print("> end")
