//
//  TextInput_ViewController.swift
//  Aphasia_com
//
//  Created by Sam Paterson on 17/05/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

class TextInput_ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var stringArray = [String]()
    
    @IBAction func done(_ sender: Any) {
        if textField.text != ""{
            performSegue(withIdentifier: "TIToResult_segue", sender: self)
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "TIToResult_segue")
        {
            var resultController = segue.destination as! TextResult_ViewController
            resultController.inputString = textField.text!
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
