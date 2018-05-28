//
//  TextResult_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

///
/// Result of converting image to text ...?
///
class TextResult_ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    /// Reference to the label which will display the result of converting images to text ...?
    @IBOutlet weak var resultLabel: UILabel!
    
    var inputString = String()
    var cellsToBeShown = [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String)]()
    
    
    /**
     * @Sam description
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = inputString //shows at bottom what was typed
        //wordsToBeShown = Utility.instance.getSentenceToWords(inputString, .whitespaces)
        //print("> words to be shown", wordsToBeShown)
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TIToInput_segue")
        {
            let inputController = segue.destination as! TextInput_ViewController
            //inputController.showErrors(wordsToBeShown, errorArray)
//            resultController.inputString = textField.text!
        }
    }
    
    
    /**
     * @Sam description.
     *
     *  - Parameters:
     *      - collectionView:   The collection view requesting this information.
     *      - section:          An index number identifying a section in collectionView.
     *                          This index value is 0-based.
     *
     *  - Returns:  the number of rows in `section` - the length of the collection (how
     *              many cells you want).
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("> w2bs count", wordsToBeShown.count)
        return  cellsToBeShown.count  //number of images going to be shown
    }
    
    
    //collection view is the collection it's going into, indexPath is the index of the cell
    
    /**
     * @Sam description
     *
     *  - Parameters:
     *      - collectionView:   The collection view requesting this information.
     *      - indexPath:        The index path that specifies the location of the item.
     *
     *  - Returns:  a configured cell object. Must not return `nil` from this method.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextResultCell", for: indexPath) as! ImageTextResultViewCell //gives the type of the custom class that was made for the cell-----might need to create a seperate class for text->images
        
        // call a function the the cell which asigns each variable with data from a function
        // which returns a tuple with data like, image, word, suggestions etc
        
        /*let tempCell = Utility.instance.getDatabaseEntry(wordsToBeShown[indexPath.item])
        if tempCell.type == "" {
            errorArray.append(indexPath.item)
            print("> errorArray: \(errorArray)")
        } else if errorArray.count == 0 {
            cell.addData(cell: tempCell)
        }
        // idea for +... could treat as a cell but just manually chnage the size of the cell in code for every 2nd cell
        if indexPath.item == wordsToBeShown.count - 1 {
            print("> return func")
            performSegue(withIdentifier: "TIToInput_segue", sender: self)
            
        }*/
        cell.addData(cell: cellsToBeShown[indexPath.item])
        return cell
    }
    
    
    /**
     * @Sam description
     *
     *  - Parameters:
     *      - collectionView:   The collection view object that is notifying you of the
     *                          selection change.
     *      - indexPath:        The index path of the cell that was selected.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // used for editing the cell
         let cell = collectionView.cellForItem(at: indexPath)
        //return cell
    }
}
