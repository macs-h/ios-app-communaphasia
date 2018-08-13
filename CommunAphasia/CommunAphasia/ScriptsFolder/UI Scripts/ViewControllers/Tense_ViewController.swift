//
//  Tense_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 8/9/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    protocol which must be implemented
 */
protocol TenseDelegate: class {
    func selectedTense(cell: ImageCell, tense: String, tenseType: String, indexPath: IndexPath)
}


/**
    class the controls the popup
 */
class Tense_ViewController: UIViewController {
    
    weak var delegate: TenseDelegate?
    var cell: ImageCell?
    var indexPath: IndexPath?
    var tenses: String?
    
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
    }
    
    
    /**
     sets up the popup
     
     - Parameters:
         - delegate:     what delegate to call after the button is pressed
         - cell:         what cell is being acted on
         - indexpath:    the index path of the cell selected
     */
    func setUp(delegate: TenseDelegate, cell: ImageCell, indexPath: IndexPath) {
        self.delegate = delegate
        self.cell = cell
        let image = cell.imageView.image
        PastImageView.image = image
        PresentImageView.image = image
        FutureImageView.image = image
        self.indexPath = indexPath
        //self.tenses = cell.tense.components(separatedBy: "+")
        self.tenses = cell.tense
    }
    
    /**
        Past tense selected.
     */
    @IBAction func PastButtonPressed(_ sender: Any) {
        delegate?.selectedTense(cell: cell!, tense: self.tenses!, tenseType: "past", indexPath: indexPath!)
        closePopup(sender)
    }
    
    
    /**
        Present tense selected.
     */
    @IBAction func PresentButtonPressed(_ sender: Any) {
        delegate?.selectedTense(cell: cell!, tense: self.tenses!, tenseType: "present", indexPath: indexPath!)
        closePopup(sender)
    }
    
    
    /**
        Future tense selected.
     */
    @IBAction func FutureButtonPressed(_ sender: Any) {
        delegate?.selectedTense(cell: cell!, tense: self.tenses!, tenseType: "future", indexPath: indexPath!)
        closePopup(sender)
    }
    
    /**
        Closes the popup if no option is selected
     */
    @IBAction func closePopup(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
