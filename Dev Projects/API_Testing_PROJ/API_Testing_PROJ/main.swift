//
//  main.swift
//  API_Testing_PROJ
//
//  Created by Max Huang on 11/08/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import Foundation


private class MyDelegate: NSObject, URLSessionDataDelegate {
    fileprivate var synonyms: [String] = []
    fileprivate func urlSession(_ session: URLSession,
                                dataTask: URLSessionDataTask,
                                didReceive data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [String: Any],
            let syn = dictionary["synonyms"] {
            self.synonyms = ((syn as! NSArray).componentsJoined(by: ",")).components(separatedBy: ",")
        }
    }
}


/**
 CURRENTLY RETURNS AN ARRAY OF SYNONYMS.
 */
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
    let task = session.dataTask(with: request as URLRequest)
    task.resume()
    sleep(2)
    print("DEL:", delegateObj.synonyms)
    
    // Process json data...?
}

getSynonym("dog")
