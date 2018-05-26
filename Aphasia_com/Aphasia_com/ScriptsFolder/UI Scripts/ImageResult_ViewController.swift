//
//  ImageResult_ViewController.swift
//  Aphasia_com
//
//  Created by Sam Paterson on 21/05/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

class ImageResult_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var InputImagesCollectionView: UICollectionView!
    @IBOutlet weak var resultTextLabel: UILabel!
    var selectedCellsResult = [SelectedImageViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InputImagesCollectionView.delegate = self
        InputImagesCollectionView.dataSource = self
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageResultCell", for: indexPath) as! ImageResultViewCell
        cell.addData(cell: selectedCellsResult[indexPath.item].extractData())
        return cell
    }

}
