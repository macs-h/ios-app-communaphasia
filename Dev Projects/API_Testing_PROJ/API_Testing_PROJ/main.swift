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

func getSynonym(_ word: String) -> [String]? {
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
    var timeOut = 0
    while (delegateObj.synonyms.isEmpty) {
        if timeOut >= 2000 {
            print("TIMEOUT")
            return nil
        }
        usleep(20 * 1000)  // sleep for 20 milliseconds
        timeOut += 20
    }
    return delegateObj.synonyms
}
print("> start\n")
if let s = getSynonym("dog") {
    print(s)
} else {
    print("ELSE")
}
print("\n> end")
