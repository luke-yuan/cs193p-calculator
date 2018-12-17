//
//  ViewController.swift
//  newCalculator
//
//  Created by Luke on 2/13/17.
//  Copyright © 2017 Luke Yuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var process: UILabel!
    
    private var isTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        displayValue = 0
        process.text = "="
        isTyping = false
        brain.clear()
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let current = sender.currentTitle!
        if isTyping {
            
            let labeltext = display.text!
            
            if current != "." {
                display.text = labeltext + current
            } else if !labeltext.contains(".") {
                display.text = labeltext + current
            }
        } else {
            display.text = current
        }
        isTyping = true
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if isTyping {
            brain.setOperand(displayValue)
        }
        isTyping = false
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        
        process.text = brain.result
        display.text = String(brain.resultValue)
        
    }
}

