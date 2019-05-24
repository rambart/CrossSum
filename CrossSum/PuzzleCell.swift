//
//  PuzzleCell.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PuzzleCell: UICollectionViewCell {
    
    var interactable = false {
        didSet {
            self.isUserInteractionEnabled = interactable
        }
    }
    var pen = 0 {
        didSet {
            if pen != 0 {
                setPen(mark:"\(pen)")
            } else {
                setPencil(marks: pencil)
            }
        }
    }
    var pencil = "" {
        didSet {
            setPencil(marks: pencil)
        }
    }
    
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
    
    func setInteraction(_ isInteractable: Bool) {
        if !isInteractable {
            backgroundColor = UIColor.lightGray
            penLabel.textColor = UIColor.black
            interactable = false
        } else {
            backgroundColor = UIColor.white
            penLabel.textColor = UIColor.black
            interactable = true
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
            label?.isOpaque = false
        }
        for digit in marks {
            guard let number = Int(String(digit)) else { return }
            pencilLabels[number - 1]?.isOpaque = true
        }
    }
    
    func setPen(mark: String) {
        pencilStack.isHidden = true
        penLabel.isHidden = false
        penLabel.text = mark
    }
    
}

func answerForCell(_ index: Int) -> Int? {
    switch index {
    case 0:
        return 0
    case 2:
        return 1
    case 4:
        return 2
    case 12:
        return 3
    case 14:
        return 4
    case 16:
        return 5
    case 24:
        return 6
    case 26:
        return 7
    case 28:
        return 8
    default:
        return nil
    }
}
