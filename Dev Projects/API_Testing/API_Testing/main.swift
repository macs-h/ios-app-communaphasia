//
//  main.swift
//  API_Testing
//
//  Created by Max Huang on 10/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation

private class MyDelegate: NSObject, URLSessionDataDelegate {
    fileprivate func urlSession(_ session: URLSession,
                                dataTask: URLSessionDataTask,
                                didReceive data: Data) {
        if let dataStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print(dataStr)
        }
    }
}

func myCallback(data: Data?, response: URLResponse?, error: Error?) {
    if let rcvdData = data {
        if let dataStr = NSString(data: rcvdData as Data, encoding:
            String.Encoding.utf8.rawValue) {
            print(dataStr)
            print("TEST")
        }
    }
}

func getSynonym(_ word: String) {
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
//    let task = session.dataTask(with: request as URLRequest)
//    task.resume()
//    sleep(2)
}

let url = URL(string: "http://cs.otago.ac.nz")
var session = URLSession.shared
var task = session.dataTask(with: url!, completionHandler: myCallback)
task.resume()
sleep(5)
