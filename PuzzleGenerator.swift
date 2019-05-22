//
//  PuzzleGenerator.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import GameKit

func generatePuzzle() -> (answers: [Int], ops: [String], sums: [Int]) {
    
    var isValid = false
    var validAnswers = [Int]()
    var validOps = [String]()
    var validSums = [Int]()
    
    while !isValid {
        let answers = randomIntArray()
        let ops = randomOperators()
        let test = testPuzzle(answers: answers, operators: ops)
        if test.0 {
            isValid = true
            validAnswers = answers
            validOps = ops
            validSums = test.1
        }
    }
    
    return (validAnswers, validOps, validSums)
}


func randomIntArray() -> [Int] {
    var ints = [1,2,3,4,5,6,7,8,9]
    ints.shuffle()
    return ints
}

func randomOperators() -> [String] {
    var characterSet = ["×", "+", "-", "÷"]
    
    var characters = [String]()
    for _ in 1...12 {
        characterSet.shuffle()
        characters.append(characterSet.first!)
    }
    return characters
}

func testPuzzle(answers: [Int], operators: [String]) -> (Bool, [Int]) {
    
    let top1 = testOperator(answers[0], operators[0], answers[1])
    let top2 = testOperator(top1.1, operators[1], answers[2])
    let hMid1 = testOperator(answers[3], operators[5], answers[4])
    let hMid2 = testOperator(hMid1.1, operators[6], answers[5])
    let bot1 = testOperator(answers[6], operators[10], answers[7])
    let bot2 = testOperator(bot1.1, operators[11], answers[8])
    
    let left1 = testOperator(answers[0], operators[2], answers[3])
    let left2 = testOperator(left1.1, operators[7], answers[6])
    let vMid1 = testOperator(answers[1], operators[3], answers[4])
    let vMid2 = testOperator(vMid1.1, operators[8], answers[7])
    let right1 = testOperator(answers[2], operators[4], answers[5])
    let right2 = testOperator(right1.1, operators[9], answers[8])
    
    let results = [top2.1, hMid2.1, bot2.1, left2.1, vMid2.1, right2.1]
    let success = top1.0 &&
    top2.0 &&
    hMid1.0 &&
    hMid2.0 &&
    bot1.0 &&
    bot2.0 &&
    left1.0 &&
    left2.0 &&
    vMid1.0 &&
    vMid2.0 &&
    right1.0 &&
    right2.0
    
    return (success, results)
}

func testOperator(_ firstNumber: Int, _ operat: String, _ secondNumber: Int) -> (Bool, Int) {
    var success = true
    var result = 0
    switch operat {
    case "×":
        result = firstNumber * secondNumber
        success = result <= 99
    case "+":
        result = firstNumber + secondNumber
        success = result <= 99
    case "-":
        result = firstNumber - secondNumber
        success = result >= 0
    case "÷":
        result = firstNumber / secondNumber
        success = firstNumber % secondNumber == 0
    default:
        success = false
        result = 0
    }
    
    return (success, result)
    
}
