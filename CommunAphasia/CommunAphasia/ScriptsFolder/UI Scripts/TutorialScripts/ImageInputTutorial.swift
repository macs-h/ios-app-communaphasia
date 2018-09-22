//
//  ImageInputTutorial.swift
//  CommunAphasia
//
//  Created by Mitchel Maluschnig on 9/18/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

class ImageInputTutorial: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("begin tutorial")
        
    }
}

class TutorialStep {
    var window: CGRect
    var message:String
    var messagePos:CGPoint
    var clickRect:CGRect
    
    init(window: CGRect,message:String,messagePos:CGPoint,clickRect:CGRect) {
        self.window = window
        self.message = message
        self.messagePos = messagePos
        self.clickRect = clickRect
    }

}

//Source: https://gist.github.com/aldo-jlaurenstin/2ed6569b1a3746645143
class MakeTransparentHoleOnOverlayView: UIView {
    var tapCount:Int = 0
    var eventQueue:[TutorialStep] = [
        TutorialStep(window: CGRect(x: 985-5, y: 149-5, width: 66+10, height: 486+10), message: "Cycle through Categories", messagePos: CGPoint(x: 500, y: 300),clickRect: CGRect(x: 985+6, y: 149+9, width: 55, height: 52)),
        TutorialStep(window: CGRect(x: 100, y: 100, width: 200, height: 200), message: "2nd step", messagePos: CGPoint(x: 300, y: 300), clickRect:CGRect(x: 100, y: 100, width: 200, height: 200))]
    
    var currentStep:TutorialStep =
        TutorialStep(window: CGRect(x: 100, y: 100, width: 200, height: 200), message: "0th step", messagePos: CGPoint(x: 300, y: 300), clickRect:CGRect(x: 100, y: 100, width: 200, height: 200))
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var passThrough: PassthroughView!
    @IBOutlet weak var exitButton: UIButton!
    //    //allow presses below UIView
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if currentStep.clickRect.contains(point){
            //this means there was a tap inside the highlighted area
            //do the next tute step NOTE: this happens twice.
            tapCount += 1
            if tapCount%2 == 0 {
                print("tapped \(tapCount)")
                if !eventQueue.isEmpty{
                    currentStep = eventQueue.removeFirst()
                    messageLabel.frame = CGRect(origin: currentStep.messagePos, size: messageLabel.frame.size)
                    messageLabel.text = currentStep.message
//                    messageLabel.backgroundColor = UIColor.clear
                    drawRect(newRect: currentStep.window)
                }
            }
            let view = super.hitTest(point, with: event)
            return view == self ? nil : view
        }else if currentStep.window.contains(point){
            //pass on event to parent view controller
            let view = super.hitTest(point, with: event)
            return view == self ? nil : view
        }else if exitButton.frame.contains(point){
            exitButton.sendActions(for: .touchUpInside)
        }
        return self
    }
    
    // Drawing
    
    func drawRect(newRect: CGRect) {
        // Ensures to use the current background color to set the filling color
        //self.backgroundColor?.setFill()
        //UIRectFill(newRect)
        
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        
        // Make hole in view's overlay
        // NOTE: Here, instead of using the transparentHoleView UIView we could use a specific CFRect location instead...
        //path.addRect(passThrough.frame)
        path.addRect(newRect)
        path.addRect(bounds)
        
        layer.path = path
        layer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = layer
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if currentStep.window != nil {
            // Ensures to use the current background color to set the filling color
            self.backgroundColor?.setFill()
            UIRectFill(rect)
            
            let layer = CAShapeLayer()
            let path = CGMutablePath()
            
            // Make hole in view's overlay
            // NOTE: Here, instead of using the transparentHoleView UIView we could use a specific CFRect location instead...
            //path.addRect(passThrough.frame)
            path.addRect(self.currentStep.window)
            path.addRect(bounds)
            
            layer.path = path
            layer.fillRule = kCAFillRuleEvenOdd
            self.layer.mask = layer
        }
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    // Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
    
}
