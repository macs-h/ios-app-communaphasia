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
        TutorialStep(window: CGRect(x: 0, y: 0, width: 0, height: 0), message: "Tap Screen to begin tutorial", messagePos: CGPoint(x: 216, y: 90),clickRect: CGRect(x: 0, y: 0, width: 2000, height: 2000)),
        TutorialStep(window: CGRect(x: 1006-5, y: 145-5, width: 66+10, height: 486+10), message: "Cycle through Categories", messagePos: CGPoint(x: 216, y: 90),clickRect: CGRect(x: 1006+6, y: 145+9, width: 55, height: 52)),
        TutorialStep(window: CGRect(x: 686-5, y: 149-5, width: 99+10, height: 96+10), message: "Select a pronoun", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 686, y: 149, width: 99, height: 96)),
        TutorialStep(window: CGRect(x: 472-5, y: 145-5, width: 99+10, height: 96+10), message: "Now select a verb", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 472, y: 149, width: 99, height: 96)),
        TutorialStep(window: CGRect(x: 41-5, y: 145-5, width: 99+10, height: 96+10), message: "Nice, now select a noun", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 41, y: 149, width: 99, height: 96)),
        TutorialStep(window: CGRect(x: 150-5, y: 145-5, width: 99+10, height: 96+10), message: "Select another noun", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 150, y: 149, width: 99, height: 96)),
        TutorialStep(window: CGRect(x: 935, y: 762, width: 48, height: 32), message: "If you dont want a picture any more try deleting it", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 935, y: 762, width: 48, height: 32)),
        TutorialStep(window: CGRect(x: 1016-5, y: 759-5, width: 85+10, height: 39+10), message: "Great! Hit the done button to finish your sentence", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 1016, y: 759, width: 85, height: 39))
    ]
    var currentStep:TutorialStep
    
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
//                    messageLabel.backgroundColor = UIColor.clear
                    drawRect(step: currentStep)
                }else {
                    //end Tutorial
                }
            }
            if currentStep.message != "Cycle through Categories"{
                let view = super.hitTest(point, with: event)
                return view == self ? nil : view
            }
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
    
    func drawRect(step:TutorialStep) {
        // Ensures to use the current background color to set the filling color
        //self.backgroundColor?.setFill()
        //UIRectFill(newRect)
        
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        
        messageLabel.frame = CGRect(origin: step.messagePos, size: messageLabel.frame.size)
        messageLabel.text = step.message
        
        // Make hole in view's overlay
        // NOTE: Here, instead of using the transparentHoleView UIView we could use a specific CFRect location instead...
        path.addRect(step.window)
        
        path.addRect(bounds)
        
        layer.path = path
        layer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = layer
    }
    //initial draw
    override func draw(_ rect: CGRect) {
        drawRect(step: currentStep)
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    // Initialization
    
    required init?(coder aDecoder: NSCoder) {
        self.currentStep = eventQueue.removeFirst()
        super.init(coder: aDecoder)

    }

    override init(frame: CGRect) {
        self.currentStep = eventQueue.removeFirst()
        super.init(frame: frame)

    }
    
    
}

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
    
}
