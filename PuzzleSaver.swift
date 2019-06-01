//
//  PuzzleSaver.swift
//  CrossSum
//
//  Created by Tom on 5/28/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import Foundation
import GameKit

extension Puzzle {
    
    func savePuzzle(pen: [Int], pencil: [String], pointPenalty: Int) {
        let PuzzleDictionary: Dictionary<String, Array<Any>> = ["answers" : self.answers,
                                                                "ops" : self.ops,
                                                                "sums" : self.sums,
                                                                "pen" : pen,
                                                                "pencil" : pencil]
        guard let path = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
        }
        
        let saveFileURL = path.appendingPathComponent("unfinishedPuzzle")
        (PuzzleDictionary as NSDictionary).write(to: saveFileURL, atomically: true)
        
        UserDefaults.standard.set(saveFileURL, forKey: "savedPuzzle")
        print("saved puzzle")
    }
    
}

func loadPuzzle() -> (puzzle: Puzzle, pen: [Int], pencil: [String]) {
    let puzzle = Puzzle()
    guard let path = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask).first else {
            return (Puzzle(), [0, 0, 0, 0, 0, 0, 0, 0, 0], ["", "", "", "", "", "", "", "", ""])
    }
    
    let saveFileURL = path.appendingPathComponent("unfinishedPuzzle")
    guard let dict = NSDictionary(contentsOf: saveFileURL),
        let puzzleInfo = dict as? [String: AnyObject],
        let answers: [Int] = puzzleInfo["answers"] as? [Int],
        let ops: [String] = puzzleInfo["ops"] as? [String],
        let sums: [Int] = puzzleInfo["sums"] as? [Int],
        let pen: [Int] = puzzleInfo["pen"] as? [Int],
        let pencil: [String] = puzzleInfo["pencil"] as? [String]
        else {
            print("Unable to load Puzzle)");
            return (Puzzle(), [0, 0, 0, 0, 0, 0, 0, 0, 0], ["", "", "", "", "", "", "", "", ""])
    }
    
    do {
        try FileManager.default.removeItem(at: saveFileURL)
    } catch {
        print("Failed to delete save")
    }
    
    puzzle.answers = answers
    puzzle.ops = ops
    puzzle.sums = sums
    
    return (puzzle, pen, pencil)
}
