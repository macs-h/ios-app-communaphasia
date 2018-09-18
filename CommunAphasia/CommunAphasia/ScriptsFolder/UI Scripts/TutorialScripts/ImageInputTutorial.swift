//
//  ImageInputTutorial.swift
//  CommunAphasia
//
//  Created by Mitchel Maluschnig on 9/18/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

class ImageInputTutorial: UIViewController {
    
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
    }
    
    @IBAction func categoryPressed(_ sender: Any) {
        print("yes this happens")
    }
    
    /**
     Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//Source: https://gist.github.com/aldo-jlaurenstin/2ed6569b1a3746645143
class MakeTransparentHoleOnOverlayView: UIView {
    
    @IBOutlet weak var transparentHoleView: UIView!
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.transparentHoleView != nil {
            // Ensures to use the current background color to set the filling color
            self.backgroundColor?.setFill()
            UIRectFill(rect)
            
            let layer = CAShapeLayer()
            let path = CGMutablePath()
            
            // Make hole in view's overlay
            // NOTE: Here, instead of using the transparentHoleView UIView we could use a specific CFRect location instead...
            path.addRect(transparentHoleView.frame)
            path.addRect(bounds)
            
            layer.path = path
            layer.fillRule = kCAFillRuleEvenOdd
            self.layer.mask = layer
        }
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
