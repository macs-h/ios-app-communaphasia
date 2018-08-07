//
//  main.swift
//  tmp
//
//  Created by Max Huang on 4/08/18.
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

func getSynonym(_ word: String) {
    let string = "https://wordsapiv1.p.mashape.com/words/stack/synonyms"
    let url = NSURL(string: string)
    let request = NSMutableURLRequest(url: url! as URL)
    request.setValue("yTv8TIqHmimshZvfKLil4h6A2zT2p11GQe5jsnr4XhZtyt69bm", forHTTPHeaderField: "X-Mashape-Key")
    request.setValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "X-Mashape-Host")
    request.httpMethod = "GET"
    
    let delegateObj = MyDelegate()
    let session = URLSession(configuration: URLSessionConfiguration.default,
                             delegate: delegateObj,
                             delegateQueue: nil)
    let task = session.dataTask(with: request as URLRequest)
    task.resume()
}


print("> start")
getSynonym("stack")
sleep(2)
print("> end")
