//
//  TextResult_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

class TextResult_ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    
    var inputString = String()
    var wordsToBeShown = [String]()
    var exclusionList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = inputString //shows at bottom what was typed
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //returns the length of the collection (how many cells you want)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  wordsToBeShown.count//number of images going to be shown
    }
    
    
    //collection view is the collection it's going into, indexPath is the index of the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SelectViewCell //gives the type of the custom class that was made for the cell-----might need to create a seperate class for text->images
        
        
        //call a function the the cell which asigns each variable with data from a function
        //which returns a tuple with data like, image, word, suggestions etc
        //------cell.addData(cell.addData(UTILITY.getDatabaseEntry(wordsToBeShown[indexPath], "temp type", exclusionList)))
        //idea for +... could treat as a cell but just manually chnage the size of the cell in code for every 2nd cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // used for editing the cell
         let cell = collectionView.cellForItem(at: indexPath)
        //return cell
    }
}
