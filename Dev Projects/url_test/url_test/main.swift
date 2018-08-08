//
//  main.swift
//  url_test
//
//  Created by Max Huang on 7/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation

let url = NSURL(string: "https://wordsapiv1.p.mashape.com/words/stack/synonyms")
var request = NSMutableURLRequest(url: url! as URL)
request.setValue("yTv8TIqHmimshZvfKLil4h6A2zT2p11GQe5jsnr4XhZtyt69bm", forHTTPHeaderField: "X-Mashape-Key")
request.setValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "X-Mashape-Host")
request.httpMethod = "GET"


func myCallback(data: Data?, response: URLResponse?, error: Error?) {
    if let rcvdData = data {
        if let dataStr = NSString(data: rcvdData as Data, encoding:
            String.Encoding.utf8.rawValue) {
            print(dataStr)
        }
    }
}
var session = URLSession.shared
var task = session.dataTask(with: request as URLRequest, completionHandler: myCallback)
task.resume()
sleep(2)
