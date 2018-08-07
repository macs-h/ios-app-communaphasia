//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


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
