//
//  TextInput_ViewController.swift
//  CommunAphasia
//
//  Created by RedSQ on 17/05/18.
//  Copyright © 2018 RedSQ. All rights reserved.
//

import UIKit

///
/// Handles the text input from the user ...??
///
class TextInput_ViewController: UIViewController {

    /// References the user input text field.
    @IBOutlet weak var textField: UITextField!
    var stringArray = [String]()
    
    /**
     * Called when the `done` button is pressed.
     *
     *  - Parameter sender: the object which called this function.
     */
    @IBAction func done(_ sender: Any) {
        if textField.text != ""{
            performSegue(withIdentifier: "TIToResult_segue", sender: self)
        }
        
    }

    /** Xcode generated **  @Sam description
     *
     * Notifies the view controller that a segue is about to be performed. Subclasses
     * override this method and use it to configure the new view controller prior to it
     * being displayed.
     *
     * The segue object contains information about the transition, including references
     * to both view controllers that are involved.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TIToResult_segue")
        {
            let resultController = segue.destination as! TextResult_ViewController
            resultController.inputString = textField.text!
        }
    }
    
    /** Xcode generated **
     *
     * Called after the controller's view is loaded into memory.
     * This method is called after the view controller has loaded its view hierarchy into
     * memory.
     *
     * You usually override this method to perform additional initialization on views
     * that were loaded from nib files.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    /** Xcode generated **
     *
     * Sent to the view controller when the app receives a memory warning.
     *
     * Your app never calls this method directly. Instead, this method is called when the
     * system determines that the amount of available memory is low.
     *
     * You can override this method to release any additional memory used by your view
     * controller. If you do, your implementation of this method must call the super
     * implementation at some point.
     */
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
