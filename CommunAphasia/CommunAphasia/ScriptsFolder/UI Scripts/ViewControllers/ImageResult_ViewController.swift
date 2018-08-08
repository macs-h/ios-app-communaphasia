//
//  ImageResult_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 21/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

///
///
///
class ImageResult_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var InputImagesCollectionView: UICollectionView!
    @IBOutlet weak var resultTextLabel: UILabel!
    var selectedCellsResult = [ImageCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InputImagesCollectionView.delegate = self
        InputImagesCollectionView.dataSource = self
       
        let convertedSentance = ImageToText.instance.createSentence(pics: selectedCellsResult)
        resultTextLabel.text = convertedSentance
        
        Utility.instance.setRecentSentence(Sentence: selectedCellsResult)
        print(Utility.instance.printRecentSentences())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //------------shows input images on screen---------//
    
    //gives the collection view how many cells it needs to hold
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCellsResult.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageResultCell", for: indexPath) as! ImageCell
        cell.addData(cell: selectedCellsResult[indexPath.item].extractData())
        return cell
    }

}