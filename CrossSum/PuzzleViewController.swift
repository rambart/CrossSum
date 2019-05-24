//
//  ViewController.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController {
    
    var puzzle = Puzzle()
    var puzzleZip = [String]()
    var cellSize = CGSize(width: 50, height: 50)
    var selectedCell = PuzzleCell()
    
    var answers = [0, 0, 0, 0, 0, 0, 0, 0, 0] {
        didSet {
            if answers == puzzle.answers {
                let ac = UIAlertController(title: "Solved!", message: "Congradulations!", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Next Puzzle!", style: .default) { (_) in
                    self.puzzle = Puzzle()
                    self.puzzleCollection.reloadData()
                }
                ac.addAction(okay)
                present(ac, animated: true)
            }
        }
    }
    
    var pencil = ["", "", "", "", "", "", "", "", ""]
    
    @IBOutlet weak var puzzleCollection: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        puzzleZip = puzzle.zipPuzzle()
        
        puzzleCollection.dataSource = self
        puzzleCollection.delegate = self
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cellSize = CGSize(width: (puzzleCollection.contentSize.width - 16) / 6, height: (puzzleCollection.contentSize.width - 16) / 6)
        puzzleCollection.reloadData()
        
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
    
    @IBAction func pen(_ sender: UIButton) {
        if selectedCell.isUserInteractionEnabled {
            
        }
    }

}

extension PuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCell", for: indexPath) as! PuzzleCell
        
        let answersIndex = answerForCell(indexPath.row)
        
        if answersIndex != nil {
            cell.setInteraction(false)
            if answers[answersIndex!] != 0 {
                cell.setPen(mark: "\(answers[answersIndex!])")
            } else {
                cell.setPencil(marks: pencil[answersIndex!])
            }
        } else {
            cell.setInteraction(true)
            cell.setPen(mark: puzzleZip[indexPath.row])
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.visibleCells[indexPath.row] as! PuzzleCell
    }


}

