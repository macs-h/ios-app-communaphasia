//
//  ImageInput_ViewController.swift
//  Aphasia_com
//
//  Created by Sam Paterson on 21/05/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

class ImageInput_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var InputCollectionView: UICollectionView!
    
    let UTILITY = Utility()
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
    
    @IBAction func DoneButton(_ sender: Any) {
        if selectedCollectionView.numberOfItems(inSection: 0) > 0 {
            //at least one image is selected
            performSegue(withIdentifier: "TIToResult_segue", sender: self)
        }else{
            //show warning
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "IIToResult_segue")
        {
            var resultController = segue.destination as! ImageResult_ViewController
            
        }
    }
    
    
    //-------collection view stuff---------//
    
    //gives the collection view how many cells it needs to hold
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.InputCollectionView {
            return 2//selectCellImages.count
        }else{
            //input collection View
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.InputCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SelectViewCell //gives the type of the custom class that was made for the cell
            
            //call a function the the cell whcih asigns each variable with data from a function
            //which returns a tuple with data like, image, word, suggestions etc
            //----cell.addData(UTILITY.getDatabaseEntry())
            
            //cell.cellImageView.image = selectCellImages[indexPath.item]
             return cell
        }else{
            //inputCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SelectViewCell //gives the type of the custom class that was made for the cell
            cell.addData(word: <#T##String#>, type: <#T##String#>, image: <#T##UIImage#>, suggestions: <#T##[String]#>) //using temp tuple
            return cell
        }
 
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.InputCollectionView {
        let cell = collectionView.cellForItem(at: indexPath)
            //do something with the cell
            //asign a tuple with data from a function in cell which returns its data
            // add a new cell to bottom table view using the tuple
            //remove cell from collection veiw and reload collection view with new cells
            //using previous cell as a suggestion
        }else{
            //InputCollectionView
            //show option to discard/ change
            
            
        }
    }

}
