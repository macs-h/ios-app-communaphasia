//
//  MainMenu_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit
import SQLite
import Hero

/**
    Main class for controlling the `mainMenu`.
 */
class MainMenu_ViewController: UIViewController {
    
    /**
        Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    /**
        Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tuteButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "1st Tutorial", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "1st Tutorial") {
            let destinationVC = segue.destination as! ImageInput_ViewController
            destinationVC.currentTute = 1
        }
    }

    @IBAction func TextToImageAction(_ sender: Any) {
        let textToImageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextInputVC")
        textToImageVC.hero.isEnabled = true
        textToImageVC.hero.modalAnimationType = .pageIn(direction: HeroDefaultAnimationType.Direction.left)
        self.hero.replaceViewController(with: textToImageVC)
        
    }
    @IBAction func ImageToTextAction(_ sender: Any) {
        let imageInputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageInputVC")
        imageInputVC.hero.isEnabled = true
        imageInputVC.hero.modalAnimationType =  .pageIn(direction: HeroDefaultAnimationType.Direction.left)
        self.hero.replaceViewController(with: imageInputVC)
    }
}
