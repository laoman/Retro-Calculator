//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Georgios Georgiou on 03/02/16.
//  Copyright © 2016 gig.com. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        do{
            try
                btnSound =  AVAudioPlayer(contentsOfURL: soundUrl)
                btnSound.prepareToPlay()
        }catch let err as NSError {
            print ("Error:  \(err.debugDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var outpoutLbl: UILabel!

    enum Operation: String {
        case divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = ""
    }
    
    var btnSound: AVAudioPlayer!
    var runningNumber = ""
    //if our interface is showing 0 then we are set to 0 for left!
    var leftValStr = "0"
    var rightValSt = ""
    var currentOperation : Operation = Operation.Empty
    var result = ""

    @IBAction func btnPressed(btn : UIButton){
        playSound()
        runningNumber += "\(btn.tag)"
        outpoutLbl.text = runningNumber
    }

    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.divide)
    }

    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }

    @IBAction func onAdditionPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }

    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }

    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }

    @IBAction func onClearBtnPressed(sender: AnyObject) {
        runningNumber = ""
        //if our interface is showing 0 then we are set to 0 for left!
        leftValStr = "0"
        rightValSt = ""
        currentOperation = Operation.Empty
        result = ""
        outpoutLbl.text = "0"
    }
    
    func processOperation(op: Operation){
        playSound()
        
        if currentOperation != Operation.Empty{

            if runningNumber != ""{
                rightValSt = runningNumber
                runningNumber = ""
                //just for safety but ideally is already 0!
                if leftValStr == "" {
                    leftValStr = "0"
                    print("Does it even go here ?")
                }
                switch currentOperation {
                case Operation.Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValSt)!)"
                case Operation.divide:
                    result = "\(Double(leftValStr)! / Double(rightValSt)!)"
                case Operation.Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValSt)!)"
                case Operation.Add:
                    result = "\(Double(leftValStr)! + Double(rightValSt)!)"
                default :
                    result = ""
                }
                outpoutLbl.text = result
                leftValStr = result
            }
            currentOperation = op
        }else{
            print("left \(currentOperation))")
            //Avoid loosing sync when running number = 0
            if runningNumber != "" {
                leftValStr = runningNumber
            }
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound(){
        if btnSound.playing {
            btnSound.stop()
        }
        btnSound.play()
    }
}

