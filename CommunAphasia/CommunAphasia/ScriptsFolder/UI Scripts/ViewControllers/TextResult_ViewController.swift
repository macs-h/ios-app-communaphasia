//
//  TextResult_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    Class that controls the Text result screen.
 */
class TextResult_ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // Reference to the label which will display the result of converting images to text ...?
    @IBOutlet weak var resultLabel: UILabel!
    
    var inputString = String()
    var cellsToBeShown = [(word: String, type: String, image: UIImage, suggestions: [String], grNum: String,category: String,tense: String)]()
    
    /**
        Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = inputString // Shows at bottom what was typed.
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
    }

    
    /**
        Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
        Notifies the view controller that a segue is about to be performed.
     
        - Parameters:
            - segue:    The segue object containing information about the view
                        controllers involved in the segue.
            - sender:   The object that initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TIToInput_segue") {
            let inputController = segue.destination as! TextInput_ViewController
        }
    }
    
    
    /**
        Tells the colelction view how many cells it needs to hold.

        - Parameters:
            - collectionView:   The collection view requesting this information.
            - section:          An index number identifying a section in
                                collectionView. This index value is 0-based.

        - Returns:  The number of rows in section.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("> w2bs count", wordsToBeShown.count)
        return  cellsToBeShown.count  //number of images going to be shown
    }
    
    
    /**
        Makes the items within the given collection view upto the size of the
        collectionview.

        - Parameters:
            - collectionView:   The collection view requesting this information.
            - indexPath:        The index path that specifies the location of
                                the item.

        - Returns:  a configured cell object. Must not return `nil` from this
                    method.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextResultCell", for: indexPath) as! ImageCell //gives the type of the custom class that was made for the cell-----might need to create a seperate class for text->images
        
        cell.showType()
        cell.addData(cell: cellsToBeShown[indexPath.item])
        return cell
    }
    
    
    /**
        Controls what happens if an item is selected within a collectionview.

        - Parameters:
            - collectionView:   The collection view requesting this information.
            - indexPath:        The index path that specifies the location of
                                the item.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // used for editing the cell
         let cell = collectionView.cellForItem(at: indexPath)
        //return cell
    }
}
