//
//  SinglePlural_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 27/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    makes a protocol so that the imageInput VC has to implement the delegate
 */
protocol SinglePluralDelegate: class {
    func selectedGNum(cell: ImageCell, grNum: String, indexPath: IndexPath)
}


/**
    Class that controls the singlePlural popup
 */
class SinglePlural_ViewController: UIViewController {
    
    weak var delegate: SinglePluralDelegate?
    var cell: ImageCell?
    var indexPath: IndexPath?
    
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var pluralImageView: UIImageView!
    @IBOutlet weak var backPluralImageView: UIImageView!
    
    
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
    func setUp(delegate: SinglePluralDelegate, cell: ImageCell, indexPath: IndexPath) {
        self.delegate = delegate
        self.cell = cell
        let image = cell.imageView.image
        singleImageView.image = image
        pluralImageView.image = image
        backPluralImageView.image = image
        self.indexPath = indexPath
    }
    
    /**
        The single button has been pressed (user has chosen single for that noun)
     */
    @IBAction func selectSingle(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "singular", indexPath: indexPath!)
        closePopup()
    }
    
    
    
    /**
        The plural button pressed (user has chosen plural for that noun)
     */
    @IBAction func selectPlural(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "plural", indexPath: indexPath!)
        closePopup()
    }
    
    /**
        can tap anywhere else to not choose single or plural
     */
    @IBAction func closePopup(){
        self.view.removeFromSuperview()
        
    }
    
    
}
