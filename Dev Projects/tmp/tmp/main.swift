//
//  main.swift
//  tmp
//
//  Created by Max Huang on 4/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation

public class MyDelegate: NSObject, URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession,
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

//
//    let string = "https://wordsapiv1.p.mashape.com/words/stack/synonyms"
//    let url = NSURL(string: string)
//    let request = NSMutableURLRequest(url: url! as URL)
//    request.setValue("yTv8TIqHmimshZvfKLil4h6A2zT2p11GQe5jsnr4XhZtyt69bm", forHTTPHeaderField: "X-Mashape-Key")
//    request.setValue("wordsapiv1.p.mashape.com", forHTTPHeaderField: "X-Mashape-Host")
//    request.httpMethod = "GET"
//    let session = URLSession.shared
//
//    let request1 = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//        if let resp = response as? HTTPURLResponse {
//            // Do what you want to do with your response.
//            print("response", response)
//        }
//        print("npothin")
//    }
//    request1.resume()
//}


print("> start")
getSynonym("stack")
sleep(2)
print("> end")
