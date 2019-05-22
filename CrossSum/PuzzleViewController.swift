//
//  ViewController.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        printNewPuzzle()
        
    }

    @IBAction func printNewPuzzle() {
        let puzzle = generatePuzzle()
        var answers: [Int] = puzzle.answers.reversed()
        var ops: [String] = puzzle.ops.reversed()
        var sums: [Int] = puzzle.sums.reversed()
        
        print(" \(answers.popLast()!)\(ops.popLast()!) \(answers.popLast()!)\(ops.popLast()!) \(answers.popLast()!) =\(sums.popLast()!)")
        print(" \(ops.popLast()!)  \(ops.popLast()!)  \(ops.popLast()!)")
        print(" \(answers.popLast()!)\(ops.popLast()!) \(answers.popLast()!)\(ops.popLast()!) \(answers.popLast()!) =\(sums.popLast()!)")
        print(" \(ops.popLast()!)  \(ops.popLast()!)  \(ops.popLast()!)")
        print(" \(answers.popLast()!)\(ops.popLast()!) \(answers.popLast()!)\(ops.popLast()!) \(answers.popLast()!) =\(sums.popLast()!)")
        print("\(sums.popLast()!) \(sums.popLast()!) \(sums.popLast()!)")
        print("\n\n\n")
    }

}

//extension PuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 36
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCell", for: indexPath) as! PuzzleCell
//
//    }
//
//
//
//
//
//}

