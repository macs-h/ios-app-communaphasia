//
//  ImageInput_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 21/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

///
///
///
class ImageInput_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var InputCollectionView: UICollectionView!
    
   
    var defaultWords = ["cow", "cat","apple","car","deer","man","woman","pencil","breakfast","lunch","dinner"]
    let tempCellTuple = (word: String, type: String, image: UIImage, suggestons: [String]).self
    var selectedWords = [String]()
    var selectedCells = [SelectedImageViewCell]()
    //---need to create a temp tuple to store remove cell data??
    
    //let selectCellImages: [UIImage] = [UIImage(named: "placeholder")!,]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InputCollectionView.dataSource = self
        InputCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        selectedCollectionView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     * Reference to the UI 'done' button.
     *
     *  - Parameter sender: the object which called this function.
     */
    @IBAction func DoneButton(_ sender: Any) {
        if selectedWords.count > 0 {
            //at least one image is selected
            
            performSegue(withIdentifier: "IIToResult_segue", sender: self)
        } else {
            //show warning
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IIToResult_segue") {
            //let finalSelectedWords = selectedCollectionView.visibleCells as! [SelectedImageViewCell]
            var resultController = segue.destination as! ImageResult_ViewController
            resultController.selectedCellsResult = selectedCells
            
        }
    }
    
    
    //-------collection view stuff---------//
    
    //gives the collection view how many cells it needs to hold
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.InputCollectionView {
            return defaultWords.count
        }else{
            //input collection View
            return selectedWords.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.InputCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputCell", for: indexPath) as! ImageSelectViewCell //gives the type of the custom class that was made for the cell
            
            //call a function the the cell whcih asigns each variable with data from a function
            //which returns a tuple with data like, image, word, suggestions etc
            cell.addData(cell: Utility.instance.getDatabaseEntry(defaultWords[indexPath.item]))
            //cell.cellImageView.image = selectCellImages[indexPath.item]
             return cell
        }else{
            //inputCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedCell", for: indexPath) as! SelectedImageViewCell //gives the type of the custom class that was made for the cell
            //cell.addData(cell.addData(cell: UTILITY.getDatabaseEntry(defaultWords[indexPath.row], "temp type", exclusionList))) //using temp tuple
            return cell
        }
 
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.InputCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! ImageSelectViewCell
            //do something with the cell
            
            showSinglePluralVC(cell: cell, indexPath: indexPath)
            
            /*
            selectedWords.append(cell.word)
            let insertedIndexPath = IndexPath(item: selectedWords.count-1, section: 0)
            selectedCollectionView?.insertItems(at: [insertedIndexPath]) // add a new cell to bottom table view using the tuple
            let newCell = selectedCollectionView?.cellForItem(at: insertedIndexPath) as! SelectedImageViewCell
            newCell.addData(cell: cell.extractData())
            defaultWords.remove(at: indexPath.item)//remove cell from collection veiw and reload collection view with new cells
            InputCollectionView?.deleteItems(at: [indexPath])
            //using previous cell as a suggestion
            */
        }else{
            //InputCollectionView
            //show option to discard/ change
            
            
        }
    }
    
    func showSinglePluralVC(cell: ImageSelectViewCell, indexPath: IndexPath){
        
        let singlePluralVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePluralVC") as! SinglePlural_ViewController
        
        self.addChildViewController(singlePluralVC)
        singlePluralVC.view.frame = self.view.frame
        self.view.addSubview(singlePluralVC.view)
        singlePluralVC.didMove(toParentViewController: self)
        
        singlePluralVC.setUp(delegate: self, cell: cell, indexPath: indexPath)
       /* singlePluralVC.delegate = self
        //moves these to function in single... view controller
        singlePluralVC.singleImageView.image = cell.imageView.image
        singlePluralVC.pluralImageView.image = cell.imageView.image
        singlePluralVC.backPluralImageView.image = cell.imageView.image*/
        
        
    }

}

extension ImageInput_ViewController : SinglePluralDelegate{
    
    func selectedGNum(cell: ImageSelectViewCell, grNum: String, indexPath: IndexPath) {
        selectedWords.append(cell.word)
        let insertedIndexPath = IndexPath(item: selectedWords.count-1, section: 0)
        selectedCollectionView?.insertItems(at: [insertedIndexPath]) // add a new cell to bottom table view using the tuple
        let newCell = selectedCollectionView?.cellForItem(at: insertedIndexPath) as! SelectedImageViewCell
        newCell.addData(cell: cell.extractData())
        newCell.grNum = grNum
        selectedCells.append(newCell)
        defaultWords.remove(at: indexPath.item)//remove cell from collection veiw and reload collection view with new cells
        InputCollectionView?.deleteItems(at: [indexPath])
    }
}
