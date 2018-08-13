//
//  ImageResult_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 21/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    Class that controls the Image result screen.
 */
class ImageResult_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var InputImagesCollectionView: UICollectionView!
    @IBOutlet weak var resultTextLabel: UILabel!
    var selectedCellsResult = [ImageCell]()
    
    
    /**
        Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        InputImagesCollectionView.delegate = self
        InputImagesCollectionView.dataSource = self
       
        let convertedSentance = ImageToText.instance.createSentence(pics: selectedCellsResult)
        resultTextLabel.text = convertedSentance
        
        Utility.instance.setRecentSentence(sentence: selectedCellsResult)
        print(Utility.instance.printRecentSentences())
        // Do any additional setup after loading the view.
    }

    
    /**
        Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // ----------------------------------------------------------------------
    // Shows input images on screen.
    // ----------------------------------------------------------------------
    
    /**
        Asks the `collectionView` object for the number of items in the
        specified section.
     
        - Parameters:
            - collectionView:   The collection view requesting this information.
            - section:          An index number identifying a section in
                                `collectionView`. This index value is 0-based.
     
        - Returns:  The number of rows in `section`.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCellsResult.count
    }
   
    
    /**
        Asks `collectionView` object for the cell that corresponds to the
        specified item in the collection view.
        Makes it upto the size of the `collectionView`.
     
        - Parameters:
            - collectionView:   The collection view requesting this information.
            - indexPath:        The index path that specifies the location of
                                the item.
     
        - Returns:  A configured cell object. Must not return nil.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageResultCell", for: indexPath) as! ImageCell
        cell.showType()
        cell.addData(cell: selectedCellsResult[indexPath.item].extractData())
        
        return cell
    }

}
