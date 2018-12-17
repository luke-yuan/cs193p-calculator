//
//  CalculatorBrain.swift
//  newCalculator
//
//  Created by Luke on 2/23/17.
//  Copyright © 2017 Luke Yuan. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var description = " "
    
    private var resultIsPending = true
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, String, trailing: Bool)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operations: Dictionary<String, Operation> =
        [
            "π": .Constant(M_PI),
            "e": .Constant(M_E),
            "√": .UnaryOperation(sqrt, "√", trailing: false),
            "x!": .UnaryOperation({num in
                var product = 1
                for i in 2...Int(num) {
                    product *= i
                }
                return Double(product)
            }, "!", trailing: false),
            "x²": .UnaryOperation({ $0 * $0 }, "^2", trailing: true),
            "2ˣ": .UnaryOperation({ pow(2, $0) }, "2^", trailing: false),
            "10ˣ": .UnaryOperation({ pow(10, $0) }, "10^", trailing: false),
            "+/-": .UnaryOperation({-$0}, "-", trailing: false),
            "×": .BinaryOperation({ $0 * $1 }),
            "÷": .BinaryOperation({ $0 / $1 }),
            "+": .BinaryOperation({ $0 + $1 }),
            "-": .BinaryOperation({ $0 - $1 }),
            "=": .Equals
    ]
    
    private struct PendingOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: PendingOperationInfo?
    
    mutating func clear() {
        description = " "
        accumulator = nil
        pending = nil
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if resultIsPending {
            description += String(operand)
        } else {
            description = String(operand)
        }
    }
    
    mutating func executeBinaryOperation() {
        if pending != nil && accumulator != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator!)
            pending = nil
        }
    }
    
    
    mutating func performOperation(_ symbol: String) {
        
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                description += symbol
                accumulator = value
                executeBinaryOperation()
                resultIsPending = false
            case .UnaryOperation(let function, let text, let trailing):
                if accumulator != nil {
                    if trailing {
                        if resultIsPending {
                            description += "(" + String(accumulator!) + ")" + text
                        } else {
                            description = "(" + description + ")" + text
                        }
                    } else {
                        if resultIsPending {
                            description += text + "(" + String(accumulator!) + ")"
                        } else {
                            description = text + "(" + description + ")"
                        }
                    }
                    accumulator = function(accumulator!)
                    
                }
                
                if resultIsPending {
                    executeBinaryOperation()
                }
                resultIsPending = false
                
            case .BinaryOperation(let function):
                description += symbol
                executeBinaryOperation()
                if accumulator != nil {
                    pending = PendingOperationInfo(binaryFunction: function, firstOperand: accumulator!)
                }
                resultIsPending = true
            case .Equals:
                executeBinaryOperation()
                resultIsPending = false

            }
        }
        
    }
    
    var result: String {
        if resultIsPending {
            return description + "..."
        } else {
            return description + "="
        }
    }
    
    var resultValue: Double {
        if accumulator != nil {
            return accumulator!
        } else {
            return 0
        }
    }
}
