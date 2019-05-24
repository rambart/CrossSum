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
    var selectedCell: Int?
    var score = 0 {
        didSet {
            UserDefaults.standard.set(score, forKey: "score")
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var answers = [0, 0, 0, 0, 0, 0, 0, 0, 0] {
        didSet {
            if answers == puzzle.answers {
                score += 1
                let ac = UIAlertController(title: "Solved!", message: "Congradulations!", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Next Puzzle!", style: .default) { (_) in
                    self.newPuzzle()
                }
                ac.addAction(okay)
                present(ac, animated: true)
            }
            puzzleCollection.reloadData()
        }
    }
    
    var pencil = ["", "", "", "", "", "", "", "", ""] {
        didSet{
            puzzleCollection.reloadData()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var puzzleCollection: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oldScore = UserDefaults.standard.value(forKey: "score") {
            score = oldScore as! Int
        } else {
            score = 0
        }
        
        puzzleZip = puzzle.zipPuzzle()
        
        puzzleCollection.dataSource = self
        puzzleCollection.delegate = self
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cellSize = CGSize(width: (puzzleCollection.contentSize.width - 16) / 6, height: (puzzleCollection.contentSize.width - 16) / 6)
        puzzleCollection.reloadData()
        
    }

    @IBAction func newPuzzle() {
        self.puzzle = Puzzle()
        self.puzzleZip = self.puzzle.zipPuzzle()
        self.answers = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        self.pencil = ["", "", "", "", "", "", "", "", ""]
        self.puzzleCollection.reloadData()
    }
    
    @IBAction func pencil(_ sender: UIButton) {
        if selectedCell != nil {
            if pencil[selectedCell!].contains("\(sender.tag)") {
                pencil[selectedCell!] = pencil[selectedCell!].replacingOccurrences(of: "\(sender.tag)", with: "")
            } else {
                pencil[selectedCell!].append("\(sender.tag)")
                answers[selectedCell!] = 0
            }
        }
    }
    
    @IBAction func pen(_ sender: UIButton) {
        if selectedCell != nil {
            for i in 0...8 {
                pencil[i] = pencil[i].replacingOccurrences(of: "\(sender.tag)", with: "")
            }
            if answers[selectedCell!] == sender.tag {
                answers[selectedCell!] = 0
            } else {
                answers[selectedCell!] = sender.tag
            }
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
            cell.setInteraction(true)
            if answers[answersIndex!] != 0 {
                cell.setPen(mark: "\(answers[answersIndex!])")
            } else {
                cell.setPencil(marks: pencil[answersIndex!])
            }
        } else {
            cell.setInteraction(false)
            cell.setPen(mark: puzzleZip[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = answerForCell(indexPath.row)
        print("tapped \(selectedCell ?? -100)")
    }


}

