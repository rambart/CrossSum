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
    var maxPoints = 4
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
    @IBOutlet weak var pointsLabel: UILabel!
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
        
        // Sign in
        authenticatePlayer()

        // Setup Puzzle
        puzzleZip = D.puzzle.zipPuzzle()
        puzzleCollection.dataSource = self
        puzzleCollection.delegate = self
        updatePointValue()
        
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
    
    func updatePointValue() {
        if UserDefaults.standard.bool(forKey: "Subscription") {
            maxPoints = 5
        } else {
            maxPoints = 4
        }
        pointsLabel.text = ""
        for i in 1...maxPoints {
            if i <= maxPoints - D.pointPenalty {
                pointsLabel.text?.append("★")
            } else {
                pointsLabel.text?.append("☆")
            }
        }
    }
    

    // MARK: - Buttons
    @IBAction func help() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let howToPlay = UIAlertAction(title: "How To Play", style: .default) { (_) in
            let message = "The goal of a cross sum puzzle is to enter each of the numbers 1-9 into the grid to simultaneously satify the six different equations.\n\nEach operation in a cross sum is performed from left to right or top to bottom instead of the normal order of operations. Also, each opperation cannot result in an irrational or negative number.\nFor example a row of 1-3+4=2 is not legal as 1-3 results in a negative number. 4-3+1=2 would however be legal. A row of 3÷2×4=6 is similarly illegal as 3÷2 is an irrational number.\n\nIf you need more help, tap the ☑︎ button to show which boxes have been filled in incorrectly.\n\nThe stars above each puzzle represents how many points the puzzle is worth. Each puzzle can earn you up to 4 points to help you climb the leaderboard (or 5 points if you have a subscription). Each time you check for errors the puzzle becomes worth 1 less point so be careful."
            let htp = UIAlertController(title: "How To Play", message: message, preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Got it", style: .cancel)
            htp.addAction(dismiss)
            self.present(htp, animated: true)
        }
        let purchaseMonthly = UIAlertAction(title: "Start Monthly Subscription", style: .default) { (_) in
            // IAPService.shared.purchase("Rambart.CrossSumUnlimited.Monthly")
            let sub = UserDefaults.standard.bool(forKey: "Subscription")
            UserDefaults.standard.set(!sub, forKey: "Subscription")
            self.updatePointValue()
        }
        let purchaseYearly = UIAlertAction(title: "Start Yearly Subscription", style: .default) { (_) in
            IAPService.shared.purchase("Rambart.CrossSumUnlimited.Subscription")
        }
        let restorePurchases = UIAlertAction(title: "Restore Purchases", style: .default) { (_) in
            IAPService.shared.paymentQueue.restoreCompletedTransactions()
            let ac = UIAlertController(title: "Restored", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .cancel))
            self.present(ac, animated: true)
        }
        let close = UIAlertAction(title: "Close", style: .cancel)
        ac.addAction(howToPlay)
        ac.addAction(purchaseMonthly)
        ac.addAction(purchaseYearly)
        ac.addAction(restorePurchases)
        ac.addAction(close)
        present(ac, animated: true)
    }
    
    @IBAction func checkForErrors() {
        let ac = UIAlertController(title: "Check For Errors", message: "This will highlight all incorrect squares and decrease the puzzle's point value by 1.", preferredStyle: .alert)
        let doIt = UIAlertAction(title: "Do It", style: .default) { (_) in
            if (self.maxPoints - self.D.pointPenalty) > 1 {
                self.D.pointPenalty += 1
                self.updatePointValue()
            }
            for i in 0...8 {
                if self.D.pen[i] != 0 && self.D.pen[i] != self.D.puzzle.answers[i] {
                    self.puzzleCollection.cellForItem(at: IndexPath(item: cellForAnswer(i)!, section: 0))?.backgroundColor = UIColor.red
                }
            }
            if UserDefaults.standard.bool(forKey: "Subscription") {
                let confirm = UIAlertController(title: "Complete", message: "Incorrect answers have been highlighted", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel)
                confirm.addAction(okay)
                self.present(confirm, animated: true)
            } else {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Interstital not ready")
                }
            }
        }
        let close = UIAlertAction(title: "Close", style: .cancel)
        ac.addAction(doIt)
        ac.addAction(close)
        present(ac, animated: true)
    }
    
    @IBAction func newPuzzle(sender: UIButton?) {
        func createNewPuzzle() {
            self.D.puzzle = Puzzle()
            self.puzzleZip = self.D.puzzle.zipPuzzle()
            self.D.pen = [0, 0, 0, 0, 0, 0, 0, 0, 0]
            self.D.pencil = ["", "", "", "", "", "", "", "", ""]
            self.puzzleCollection.reloadData()
            self.updatePointValue()
            self.highlightBtns()
            print("Answers: \(self.D.puzzle.answers)")
        }
        if sender != nil {
            let ac = UIAlertController(title: "Abandon Puzzle?", message: "This will delete the current puzzle and devalue the next puzzle", preferredStyle: .alert)
            let doIt = UIAlertAction(title: "Do It", style: .default) { (_) in
                self.D.pointPenalty = 1
                createNewPuzzle()
                if self.interstitial.isReady && !UserDefaults.standard.bool(forKey: "Subscription"){
                    self.interstitial.present(fromRootViewController: self)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            ac.addAction(doIt)
            ac.addAction(cancel)
            present(ac, animated: true)
        } else {
            D.pointPenalty = 0
            createNewPuzzle()
        }
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
                    self.newPuzzle(sender: nil)
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
