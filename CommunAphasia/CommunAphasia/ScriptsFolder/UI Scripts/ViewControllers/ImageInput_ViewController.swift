//
//  ImageInput_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 21/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

/**
    Controls everything on the image input screen.
 */
class ImageInput_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var InputCollectionView: UICollectionView!
    
    var commonWords = ["cow", "cat","apple","car","deer","man","woman","pencil","breakfast",
                        "lunch","dinner","basketball","fish","soda","tree","eating","sleeping",
                        "calling","big","small","red","blue","I","fast","quickly","waiting","want","need","may","can","should","he","she","it","they","we","you"]
    var selectedWords = [String]()
    var selectedCells = [ImageCell]()
    
    // Category UI things.
    @IBOutlet var tabButtons: [UIButton]! // array of tab buttons
    let tabColour: [String] = ["e0f0ea", "def2f1", "d9eceb", "cfe3e2", "bed3d2", "aec8c7", "9ab8b6", "8facab"]
    var currentCategoyIndex = 0
    private var cellsInCategory: [(String, String, UIImage, [String], String, String, String)]! //temp storage to be used by collection view cells
    let categories = ["common","emotions","animals","food","activity","travel","objects","other"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InputCollectionView.dataSource = self
        InputCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        selectedCollectionView.delegate = self
        
        // Colourises the tabs
        for button in tabButtons{
            button.setImage(UIImage(named: "Current tab")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.tintColor = UIColor(hex: tabColour[button.tag])
        }
        ChangeCategory(tabButtons[0])
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
        Reference to the UI 'done' button.

        - Parameter sender: the object which called this function.
     */
    @IBAction func DoneButton(_ sender: Any) {
        if selectedWords.count > 0 {
            // At least one image is selected
            ImageToText.instance.reset()
            performSegue(withIdentifier: "IIToResult_segue", sender: self)
        } else {
            //no picture selectect so show warning?
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IIToResult_segue") {
            let resultController = segue.destination as! ImageResult_ViewController
            resultController.selectedCellsResult = selectedCells
            
        }
    }
    
    
    /**
        Called when a tab is pressed and uses the tab tag to determine what category to use
     
        - Parameter sender: tab button pressed
     */
    @IBAction func ChangeCategory(_ sender: UIButton) {
        for button in tabButtons {
            if button.tag == currentCategoyIndex {
                button.imageView?.tintColor = UIColor(hex: tabColour[button.tag])
            }
            if button.tag == sender.tag {
                //new tab to be selected
                 button.imageView?.tintColor = UIColor(hex: "ffffff")
            }
            //print("button colour", button.imageView!.tintColor)
        }
        if sender.tag == 0 {
            cellsInCategory = Utility.instance.getWordsInDatabase(words: commonWords)
        } else {
            cellsInCategory = Utility.instance.getCellsByCategory(category: categories[sender.tag])
        }
        InputCollectionView?.reloadData()
        currentCategoyIndex = sender.tag
    }
    
    
    
    // ----------------------------------------------------------------------
    // Collection view stuff.
    // ----------------------------------------------------------------------
    

    /**
        Tells the colelction view how many cells it needs to hold.
     
        - Parameters:
            - collectionView:           the collection view which number of items
                                        is being set
            - numberOfItemsInSelection: number of items in section
     
        - Returns:  the size of the given collecvtion view
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.InputCollectionView {
            return cellsInCategory.count
        } else {
            // Input collection View
            return selectedWords.count
        }
    }
    
    
    /**
        Makes the items within the given collection view upto the size of the
        collectionview
     
        - Parameters:
            - collectionView:   the collection view which cells are being created in
            - indexPath:        the index of the current cell which is being worked on
     
        - Returns:  the item that has been made
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.InputCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputCell", for: indexPath) as! ImageCell //gives the type of the custom class that was made for the cell
            
            // call a function the the cell whcih asigns each variable with data from a function
            // which returns a tuple with data like, image, word, suggestions etc
            cell.addData(cell: cellsInCategory[indexPath.item])
            cell.showType()
            return cell
        } else {
            // InputCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedCell", for: indexPath) as! ImageCell //gives the type of the custom class that was made for the cell
            cell.showType()
            return cell
        }
    }
    
    
    /**
        called when the want button is pressed
     */
    @IBAction func wantButtonPress(_ sender: Any) {
        selectedWords.append("want")
        
        let insertedIndexPath = IndexPath(item: selectedWords.count-1, section: 0)
        selectedCollectionView?.insertItems(at: [insertedIndexPath]) // add a new cell to bottom table view using the tuple
        let newCell = selectedCollectionView?.cellForItem(at: insertedIndexPath) as! ImageCell
        newCell.addData(cell: (word: "want", type: wordType.modal.rawValue, image: UIImage(named: "image placeholder")!, suggestions: [""], grNum: "",category: "",tense: ""))
        selectedCells.append(newCell)
    }
    
    
    /**
        Controls what happens if an item is selected within a collectionview
     
        - Parameters:
            - collectionView:   the collection view which had an item selected within
            - indexPath:        indexpath of the item that was selected
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.InputCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
            //do something with the cell
            if cell.type == wordType.noun.rawValue {
                showSinglePluralVC(cell: cell, indexPath: indexPath)
            } else if cell.type == wordType.verb.rawValue || cell.type == wordType.modal.rawValue {
                showTenseVC(cell: cell, indexPath: indexPath)
            } else {
                selectedWords.append(cell.word)
                let insertedIndexPath = IndexPath(item: selectedWords.count-1, section: 0)
                selectedCollectionView?.insertItems(at: [insertedIndexPath]) // add a new cell to bottom table view using the tuple
                let newCell = selectedCollectionView?.cellForItem(at: insertedIndexPath) as! ImageCell
                newCell.addData(cell: cell.extractData())
                selectedCells.append(newCell)
                //using previous cell as a suggestion
            }
        } else {
            //InputCollectionView
            //show option to discard/ change
        }
    }
    
    
    /**
        Bring up the popup that asks for single or plural
     
        - Parameters:
            - cell:         the cell that was pressed
            - indexPath:    the indexpath of the cell that was pressed
     */
    func showSinglePluralVC(cell: ImageCell, indexPath: IndexPath) {
        let singlePluralVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePluralVC") as! SinglePlural_ViewController
        
        self.addChildViewController(singlePluralVC)
        singlePluralVC.view.frame = self.view.frame
        self.view.addSubview(singlePluralVC.view)
        singlePluralVC.didMove(toParentViewController: self)
        
        singlePluralVC.setUp(delegate: self, cell: cell, indexPath: indexPath)
    }
    
    
    /**
        Shows the tense popup giving user otption to choose past, present,
        future tense
     
        - Parameters:
            - cell:         the cell that was pressed
            - indexPath:    the indexpath of the cell that was pressed
     */
    func showTenseVC(cell: ImageCell, indexPath: IndexPath) {
        let tenseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tenseVC") as! Tense_ViewController
        
        self.addChildViewController(tenseVC)
        tenseVC.view.frame = self.view.frame
        self.view.addSubview(tenseVC.view)
        tenseVC.didMove(toParentViewController: self)
        
        tenseVC.setUp(delegate: self, cell: cell, indexPath: indexPath)
      
    }
    
    
    /*
        Called by the delete button to remove an already selected cell
     */
    @IBAction func deleteSelectedCell(_ sender: Any) {
        if selectedCells.count > 0 {
            let indexPath = IndexPath(item: selectedWords.count-1, section: 0)
            selectedCells.remove(at: indexPath.item) //removes from the list of selected cells
            selectedWords.remove(at: indexPath.item) //removes word from selected word (needs to be done before deleteing item because its the data source)
            selectedCollectionView?.deleteItems(at: [indexPath]) //removes from input collection view
        }
    }

} // End of ImageInput_ViewController class!


/**
    Adds a delegate to the ImageInput_ViewCOntroller so that it can get things from
    the pulural/single popup
 */
extension ImageInput_ViewController : SinglePluralDelegate{
    func selectedGNum(cell: ImageCell, grNum: String, indexPath: IndexPath) {
        selectedWords.append(cell.word)
        let insertedIndexPath = IndexPath(item: selectedWords.count-1, section: 0)
        selectedCollectionView?.insertItems(at: [insertedIndexPath]) // add a new cell to bottom table view using the tuple
        let newCell = selectedCollectionView?.cellForItem(at: insertedIndexPath) as! ImageCell
        newCell.addData(cell: cell.extractData())
        if grNum == "singular"{
            newCell.grNum = grNum
        }else if newCell.grNum == "r"{
            newCell.grNum = "plural"
        }
        if grNum == "plural"{
            newCell.showPlural()
        }
        selectedCells.append(newCell)
        
    }
}


/**
     Adds a delegate to the ImageInput_ViewCOntroller so that it can get things from
     the tense popup
 */
extension ImageInput_ViewController : TenseDelegate{
    func selectedTense(cell: ImageCell, tense: String, tenseType: String, indexPath: IndexPath){
        selectedWords.append(cell.word)
        let insertedIndexPath = IndexPath(item: selectedWords.count-1, section: 0)
        selectedCollectionView?.insertItems(at: [insertedIndexPath]) // add a new cell to bottom table view using the tuple
        
        let newCell = selectedCollectionView?.cellForItem(at: insertedIndexPath) as! ImageCell
        newCell.addData(cell: cell.extractData())
        newCell.tense = tense
        newCell.tenseType = tenseType
        newCell.showTense(tenseType: tenseType)
        selectedCells.append(newCell)
    }
}
