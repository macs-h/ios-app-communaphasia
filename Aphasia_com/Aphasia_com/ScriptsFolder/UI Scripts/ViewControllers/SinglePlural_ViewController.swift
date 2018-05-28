//
//  SinglePlural_ViewController.swift
//  Aphasia_com
//
//  Created by Sam Paterson on 27/05/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit
protocol SinglePluralDelegate: class {
    func selectedGNum(cell: ImageSelectViewCell, grNum: String, indexPath: IndexPath)
}
class SinglePlural_ViewController: UIViewController {
    
    weak var delegate: SinglePluralDelegate?
    
    var cell: ImageSelectViewCell?
    
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
        //
    }
    
    
    func setUp(delegate: SinglePluralDelegate, cell: ImageSelectViewCell, indexPath: IndexPath){
        self.delegate = delegate
        self.cell = cell
        let image = cell.imageView.image
        singleImageView.image = image
        pluralImageView.image = image
        backPluralImageView.image = image
        self.indexPath = indexPath
    }
    
    //single image selected
    @IBAction func selectSingle(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "single", indexPath: indexPath!)
        closePopup()
    }
    
    //plural image selected
    @IBAction func selectPlural(_ sender: Any) {
        delegate?.selectedGNum(cell: cell!, grNum: "plural", indexPath: indexPath!)
        closePopup()
    }
    
    @IBAction func closePopup(){
        self.view.removeFromSuperview()
        
    }
    
    
}
