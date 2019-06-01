//
//  ViewController.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds

class PuzzleViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Attributes
    var puzzleZip = [String]()
    var cellSize = CGSize(width: 50, height: 50)
    var selectedCell: Int? {
        didSet {
            puzzleCollection.reloadData()
        }
    }
    var score = 0 {
        didSet {
            UserDefaults.standard.set(score, forKey: "score")
            scoreLabel.text = "Score: \(score)"
            DispatchQueue.global(qos: .background).async {
                self.saveScore(score: self.score)
            }
        }
    }
    let D = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Google Ads
    var interstitial: GADInterstitial!

    
    // MARK: - Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var puzzleCollection: UICollectionView!
    @IBOutlet weak var pen1Btn: UIButton!
    @IBOutlet weak var pen2Btn: UIButton!
    @IBOutlet weak var pen3Btn: UIButton!
    @IBOutlet weak var pen4Btn: UIButton!
    @IBOutlet weak var pen5Btn: UIButton!
    @IBOutlet weak var pen6Btn: UIButton!
    @IBOutlet weak var pen7Btn: UIButton!
    @IBOutlet weak var pen8Btn: UIButton!
    @IBOutlet weak var pen9Btn: UIButton!
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticatePlayer()

        puzzleZip = D.puzzle.zipPuzzle()
        
        puzzleCollection.dataSource = self
        puzzleCollection.delegate = self
        
        interstitial = createAndLoadInterstitial()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cellSize = CGSize(width: (puzzleCollection.contentSize.width - 16) / 6, height: (puzzleCollection.contentSize.width - 16) / 6)
        puzzleCollection.reloadData()
        highlightBtns()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: intersitialAdID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    

    // MARK: - Buttons
    @IBAction func checkForErrors() {
        for i in 0...8 {
            if D.pen[i] != 0 && D.pen[i] != D.puzzle.answers[i] {
                puzzleCollection.cellForItem(at: IndexPath(item: cellForAnswer(i)!, section: 0))?.backgroundColor = UIColor.red
            }
        }
        let ac = UIAlertController(title: "Complete", message: "Incorrect answers have been highlighted", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .cancel)
        ac.addAction(okay)
        present(ac, animated: true)
    }
    
    @IBAction func newPuzzle() {
        D.puzzle = Puzzle()
        puzzleZip = D.puzzle.zipPuzzle()
        D.pen = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        D.pencil = ["", "", "", "", "", "", "", "", ""]
        puzzleCollection.reloadData()
        highlightBtns()
        print("Answers: \(D.puzzle.answers)")
    }
    
    @IBAction func pencil(_ sender: UIButton) {
        if selectedCell != nil {
            if D.pencil[selectedCell!].contains("\(sender.tag)") {
                D.pencil[selectedCell!] = D.pencil[selectedCell!].replacingOccurrences(of: "\(sender.tag)", with: "")
            } else {
                D.pencil[selectedCell!].append("\(sender.tag)")
                D.pen[selectedCell!] = 0
            }
            puzzleCollection.reloadData()
            highlightBtns()
        }
    }
    
    @IBAction func pen(_ sender: UIButton) {
        if selectedCell != nil {
            for i in 0...8 {
                D.pencil[i] = D.pencil[i].replacingOccurrences(of: "\(sender.tag)", with: "")
            }
            if D.pen[selectedCell!] == sender.tag {
                D.pen[selectedCell!] = 0
            } else {
                D.pen[selectedCell!] = sender.tag
            }
            
            if D.pen == D.puzzle.answers {
                score += 5
                let ac = UIAlertController(title: "Solved!", message: "Congratulations!", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Next Puzzle!", style: .default) { (_) in
                    self.newPuzzle()
                    if self.interstitial.isReady {
                        self.interstitial.present(fromRootViewController: self)
                    } else {
                        print("Ad wasn't ready")
                    }
                }
                ac.addAction(okay)
                present(ac, animated: true)
            }
            puzzleCollection.reloadData()
            highlightBtns()
        }
    }
    
    func highlightBtns() {
        let penBtns = [pen1Btn, pen2Btn, pen3Btn, pen4Btn, pen5Btn, pen6Btn, pen7Btn, pen8Btn, pen9Btn]
        for btn in penBtns {
            btn?.backgroundColor = UIColor(named: "BGColor")
        }
        for pen in D.pen {
            if pen > 0 {
                penBtns[pen - 1]?.backgroundColor = UIColor(named: "light")
            }
        }
    }
    
    func setButtonInteraction() {
        let penButtons: Array<UIButton> = [pen1Btn, pen2Btn, pen3Btn, pen4Btn, pen5Btn, pen6Btn, pen7Btn, pen8Btn, pen9Btn]
        for i in 1...9 {
            if D.pen.contains(i) {
                if D.pen[selectedCell!] == i {
                    penButtons[i-1].isEnabled = true
                } else {
                    penButtons[i-1].isEnabled = false
                }
            } else {
                penButtons[i-1].isEnabled = true
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
            if D.pen[answersIndex!] != 0 {
                cell.setPen(mark: "\(D.pen[answersIndex!])")
            } else {
                cell.setPencil(marks: D.pencil[answersIndex!])
            }
            if selectedCell == answersIndex {
                cell.backgroundColor = UIColor.init(named: "Selected")
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
        if answerForCell(indexPath.row) == selectedCell {
            selectedCell = nil
        } else {
            selectedCell = answerForCell(indexPath.row)
        }
        
    }


}


extension PuzzleViewController: GKGameCenterControllerDelegate {
 
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { (view, error) in
            if view != nil {
                self.present(view!, animated: true)
            }
            self.fetchScore()
            self.fetchRank()
        }
    }
    
    func fetchRank() {
        if GKLocalPlayer.local.isAuthenticated {
            let lb = GKLeaderboard()
            lb.identifier = "HighScore"
            lb.timeScope = .allTime
            lb.loadScores { (scores, error) in
                guard error == nil else {return}
                if (scores?.count ?? 0) > 0 {
                    self.rankLabel.text = "Global Rank: \(lb.localPlayerScore!.rank)"
                    print("rank Update: \(lb.localPlayerScore!.rank)")
                }
            }
        }
    }
    
    func fetchScore() {
        if GKLocalPlayer.local.isAuthenticated {
            let lb = GKLeaderboard()
            lb.identifier = "HighScore"
            lb.loadScores { (scores, error) in
                guard error == nil else {return}
                if let localScore = lb.localPlayerScore {
                    self.score = Int(localScore.value)
                }
            }
            print("Score Update: \(score)")
        }
    }
    
    func saveScore(score: Int) {
        if GKLocalPlayer.local.isAuthenticated {
            let newScore = GKScore(leaderboardIdentifier: "HighScore")
            newScore.value = Int64(score)
            GKScore.report([newScore]) { (error) in
                self.fetchRank()
            }
        }
    }
    
    @IBAction func showLeaderBoard(){
        let gcvc = GKGameCenterViewController()
        gcvc.gameCenterDelegate = self
        present(gcvc, animated: true)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    
}
