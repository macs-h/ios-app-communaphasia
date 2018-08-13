//
//  SinglePlural_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 27/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    Makes a protocol so that the `imageInput_VC` has to implement the delegate.
 */
protocol SinglePluralDelegate: class {
    func selectedGNum(cell: ImageCell, grNum: String, indexPath: IndexPath)
}


/**
    Class that controls the `singlePlural` pop-up.
 */
class SinglePlural_ViewController: UIViewController {
    
    weak var delegate: SinglePluralDelegate?
    var cell: ImageCell?
    var indexPath: IndexPath?
    
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var pluralImageView: UIImageView!
    @IBOutlet weak var backPluralImageView: UIImageView!
    
    
    /**
        Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    
    /**
        Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
        Sets up the pop-up.
     
        - Parameters:
            - delegate:     What delegate to call after the button is pressed.
            - cell:         What cell is being acted on.
            - indexpath:    The index path that specifies the location of the
                            item.
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
        The `single` button has been pressed (user has chosen `single` for
        that noun).
     
        - Parameter sender: The object which called this function.
     */
    @IBAction func selectSingle(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "singular", indexPath: indexPath!)
        closePopup()
    }
    
    
    /**
        The `plural` button has been pressed (user has chosen `plural` for
        that noun).
     
        - Parameter sender: The object which called this function.
     */
    @IBAction func selectPlural(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "plural", indexPath: indexPath!)
        closePopup()
    }
    
    
    /**
        Can tap anywhere else to not choose `single` or `plural`.
     */
    @IBAction func closePopup(){
        self.view.removeFromSuperview()
        
    }
    
    
}
