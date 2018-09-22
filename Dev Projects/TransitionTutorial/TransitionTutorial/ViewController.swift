//
//  ViewController.swift
//  TransitionTutorial
//
//  Created by Max Huang on 22/09/18.
//  Copyright © 2018 Max Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let transitionManager = TransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destination as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager as? UIViewControllerTransitioningDelegate
        
    }

}

