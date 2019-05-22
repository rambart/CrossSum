//
//  PuzzleCell.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PuzzleCell: UICollectionViewCell {
    
    @IBOutlet weak var penLabel: UILabel!
    
    @IBOutlet weak var pencilStack: UIStackView!
    @IBOutlet weak var pencil1Label: UILabel!
    @IBOutlet weak var pencil2Label: UILabel!
    @IBOutlet weak var pencil3Label: UILabel!
    @IBOutlet weak var pencil4Label: UILabel!
    @IBOutlet weak var pencil5Label: UILabel!
    @IBOutlet weak var pencil6Label: UILabel!
    @IBOutlet weak var pencil7Label: UILabel!
    @IBOutlet weak var pencil8Label: UILabel!
    @IBOutlet weak var pencil9Label: UILabel!
    
    func setInteraction(_ isPartOfPuzzle: Bool) {
        if isPartOfPuzzle {
            backgroundColor = UIColor.black
            penLabel.textColor = UIColor.white
        } else {
            backgroundColor = UIColor.black
            penLabel.textColor = UIColor.white
        }
    }
    
    func setPencil(marks: String) {
        let pencilLabels = [pencil1Label,
                            pencil2Label,
                            pencil3Label,
                            pencil4Label,
                            pencil5Label,
                            pencil6Label,
                            pencil7Label,
                            pencil8Label,
                            pencil9Label]
        penLabel.isHidden = true
        pencilStack.isHidden = false
        for label in pencilLabels {
            label?.textColor = UIColor.white
        }
        for digit in marks {
            guard let number = Int(String(digit)) else { return }
            pencilLabels[number - 1]?.textColor = UIColor.darkGray
        }
    }
    
    func setPen(mark: String) {
        pencilStack.isHidden = true
        penLabel.isHidden = false
        penLabel.text = mark
    }
    
}
