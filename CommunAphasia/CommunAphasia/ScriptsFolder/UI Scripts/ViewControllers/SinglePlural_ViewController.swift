//
//  SinglePlural_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 27/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    @@@
 */
protocol SinglePluralDelegate: class {
    func selectedGNum(cell: ImageCell, grNum: String, indexPath: IndexPath)
}


/**
    @@@
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
        @@@
     
        - Parameters:
            - delegate:     @@@
            - cell:         @@@
            - indexpath:    @@@
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
    
    //single image selected
    /**
        @@@
     */
    @IBAction func selectSingle(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "singular", indexPath: indexPath!)
        closePopup()
    }
    
    
    //plural image selected
    /**
        @@@
     */
    @IBAction func selectPlural(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "plural", indexPath: indexPath!)
        closePopup()
    }
    
    
    @IBAction func closePopup(){
        self.view.removeFromSuperview()
        
    }
    
    
}
