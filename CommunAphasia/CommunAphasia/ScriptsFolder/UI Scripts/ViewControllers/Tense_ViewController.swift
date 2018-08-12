//
//  Tense_ViewController.swift
//  CommunAphasia
//
//  Created by Mitchel Maluschnig on 8/9/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

protocol TenseDelegate: class {
    func selectedTense(cell: ImageCell, tense: String, tenseType: String, indexPath: IndexPath)
}
class Tense_ViewController: UIViewController {
    
    weak var delegate: TenseDelegate?
    var cell: ImageCell?
    var indexPath: IndexPath?
    var tenses: [String]?
    
    
    @IBOutlet weak var PastImageView: UIImageView!
    
    @IBOutlet weak var PresentImageView: UIImageView!
    
    @IBOutlet weak var FutureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //
    }
    
    func setUp(delegate: TenseDelegate, cell: ImageCell, indexPath: IndexPath){
        self.delegate = delegate
        self.cell = cell
        let image = cell.imageView.image
        PastImageView.image = image
        PresentImageView.image = image
        FutureImageView.image = image
        self.indexPath = indexPath
        self.tenses = cell.tense.components(separatedBy: "+")
    }
    
    @IBAction func PastButtonPressed(_ sender: Any) {
        delegate?.selectedTense(cell: cell!, tense: self.tenses![0], tenseType: "past", indexPath: indexPath!)
        closePopup(sender)
    }
    
    @IBAction func PresentButtonPressed(_ sender: Any) {
        delegate?.selectedTense(cell: cell!, tense: self.tenses![1], tenseType: "present", indexPath: indexPath!)
        closePopup(sender)
    }
    
    @IBAction func FutureButtonPressed(_ sender: Any) {
        delegate?.selectedTense(cell: cell!, tense: self.tenses![2], tenseType: "future", indexPath: indexPath!)
        closePopup(sender)
    }
    @IBAction func closePopup(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
