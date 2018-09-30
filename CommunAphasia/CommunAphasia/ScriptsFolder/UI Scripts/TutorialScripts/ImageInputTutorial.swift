//
//  ImageInputTutorial.swift
//  CommunAphasia
//
//  Created by Mitchel Maluschnig on 9/18/18.
//  Copyright © 2018 Cosc345. All rights reserved.
//

import UIKit

class ImageInputTutorial: UIViewController {
    var tuteNum:Int = 0
    
    @IBOutlet var tuteOverlay: MakeTransparentHoleOnOverlayView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("begin tutorial")
        tuteOverlay.tuteNum = self.tuteNum
        
        tuteOverlay.setUp(num: tuteNum)
        
    }
}

class TutorialStep {
    var window: CGRect
    var message:String
    var messagePos:CGPoint
    var clickRect:CGRect
    var extraWindow:CGRect
    //should really add a 'state' field
    
    init(window: CGRect,message:String,messagePos:CGPoint,clickRect:CGRect,extraWindow: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)) {
        self.window = window
        self.message = message
        self.messagePos = messagePos
        self.clickRect = clickRect
        self.extraWindow = extraWindow
    }

}
class Tutorials {
    
    func genTute(num:Int) -> [TutorialStep] {
        if num == 1 {
            return [
                TutorialStep(window: CGRect(x: 0, y: 0, width: 0, height: 0), message: "Tap Screen to begin tutorial", messagePos: CGPoint(x: 216, y: 90),clickRect: CGRect(x: 0, y: 0, width: 2000, height: 2000)),
                TutorialStep(window: CGRect(x: 1006-5, y: 145-5, width: 66+10, height: 486+10), message: "Cycle through Categories", messagePos: CGPoint(x: 216, y: 90),clickRect: CGRect(x: 1006+6, y: 145+9, width: 55, height: 52)),
                TutorialStep(window: CGRect(x: 43, y: 145, width: 99+5, height: 96+5), message: "Select a pronoun", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 43, y: 145, width: 99, height: 96)),
                TutorialStep(window: CGRect(x: 150, y: 145, width: 99+5, height: 96+5), message: "Now select a verb", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 150, y: 145, width: 99, height: 96)),
                TutorialStep(window: CGRect(x: 366, y: 145, width: 99+5, height: 96+5), message: "Nice, now select a noun", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 366, y: 145, width: 99, height: 96)),
                TutorialStep(window: CGRect(x: 366+109, y: 145, width: 99+5, height: 96+5), message: "Select another noun", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 366+94, y: 149, width: 99, height: 96)),
                TutorialStep(window: CGRect(x: 923-5, y: 762-5, width: 58+10, height: 32+10), message: "If you dont want a picture any more try deleting it", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 923, y: 762, width: 58, height: 32)),
                TutorialStep(window: CGRect(x: 1016-5, y: 759-5, width: 85+10, height: 39+10), message: "Great! Hit the done button to finish your sentence", messagePos: CGPoint(x: 216, y: 90), clickRect:CGRect(x: 1016, y: 759, width: 85, height: 39))
            ]
        }else if num == 2 {
            return [
                TutorialStep(window: CGRect(x: 0, y: 0, width: 0, height: 0), message: "Tap Screen to begin tutorial", messagePos: CGPoint(x: 216, y: 220),clickRect: CGRect(x: 0, y: 0, width: 2000, height: 2000)),
                TutorialStep(window: CGRect(x: 166-5, y: 163-10, width: 806+115+10, height: 33+20), message: "enter the phrase: 'the large tree is green' and press done", messagePos: CGPoint(x: 216, y: 220), clickRect: CGRect(x: 988, y: 157, width: 97, height: 45)),
                TutorialStep(window: CGRect(x: 406-5, y: 504-5, width: 300+10, height: 200+10), message: "use the scroll wheel to change large to big and press done", messagePos: CGPoint(x: 216, y: 220), clickRect: CGRect(x: 988, y: 157, width: 97, height: 45),extraWindow: CGRect(x: 988-5, y: 157-5, width: 97+10, height: 45+10))
            ]
        }else {
        //default tute
            return [TutorialStep(window: CGRect(x: 0, y: 0, width: 0, height: 0), message: "sorry an error occured, tap screen to exit tutorial", messagePos: CGPoint(x: 216, y: 90),clickRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))]
        }
    }
}

//Source: https://gist.github.com/aldo-jlaurenstin/2ed6569b1a3746645143
class MakeTransparentHoleOnOverlayView: UIView {
    var tapCount:Int = 0
    var tuteNum: Int = 0
    var tutes:Tutorials = Tutorials()//class to generate tutorials
    var eventQueue:[TutorialStep] = []
    var currentStep:TutorialStep = TutorialStep(window: CGRect(x: 0, y: 0, width: 0, height: 0), message: "this is a placeholdeer", messagePos: CGPoint(x: 216, y: 90),clickRect: CGRect(x: 0, y: 0, width: 0, height: 0))
    var exitStep:TutorialStep = TutorialStep(window: CGRect(x: 0, y: 0, width: 0, height: 0), message: "tap screen to exit tutorial", messagePos: CGPoint(x: 216, y: 90),clickRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    //    //allow presses below UIView
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if currentStep.clickRect.contains(point){
            //this means there was a tap inside the highlighted area
            //do the next tute step NOTE: this happens twice (for unknown reasons)
            tapCount += 1
            if tapCount%2 == 0 {
                print("tapped \(tapCount)")
                if !eventQueue.isEmpty{
                    currentStep = eventQueue.removeFirst()
//                    messageLabel.backgroundColor = UIColor.clear
                    drawRect(step: currentStep)
                }else {
                    //exit
                    if currentStep.message == "tap screen to exit tutorial" {
                        exitButton.sendActions(for: .touchUpInside)
                    }else{
                        currentStep = exitStep
                        drawRect(step: currentStep)
                    }
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
        //if an extra window is needed idk how even odd rule works so i just added an extra rect.
        if step.extraWindow.width != 0{
            path.addRect(step.extraWindow)
            path.addRect(bounds)
            layer.path = path
            layer.fillRule = kCAFillRuleEvenOdd
            self.layer.mask = layer
            path.addRect(CGRect(x: 0, y: 0, width: 0, height: 0))
            path.addRect(bounds)
            layer.path = path
            layer.fillRule = kCAFillRuleEvenOdd
            self.layer.mask = layer
        }
    }
    //initial draw
    override func draw(_ rect: CGRect) {
        
        drawRect(step: currentStep)
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    func setUp(num:Int){
        self.eventQueue = self.tutes.genTute(num: num)
        self.currentStep = eventQueue.removeFirst()
    }
    
    
    // Initialization
    
    required init?(coder aDecoder: NSCoder) {
//        self.eventQueue = tutes.genTute(num: tuteNum)
//        self.currentStep = eventQueue.removeFirst()
        super.init(coder: aDecoder)

    }

    override init(frame: CGRect) {
//        self.eventQueue = tutes.genTute(num: tuteNum)
//        self.currentStep = eventQueue.removeFirst()
        super.init(frame: frame)

    }
    
    
}

//class PassthroughView: UIView {
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        return view == self ? nil : view
//    }
//
//}
