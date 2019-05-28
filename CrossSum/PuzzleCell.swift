//
//  PuzzleCell.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class PuzzleCell: UICollectionViewCell {
    
    var interactable = true {
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
            backgroundColor = UIColor.init(named: "BGColor")
            penLabel.textColor = UIColor.white
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
            label?.text = ""
        }
        for digit in marks {
            guard let number = Int(String(digit)) else {
                print("not a number")
                return }
            pencilLabels[number - 1]?.text = "\(number)"
        }
    }
    
    func setPen(mark: String) {
        print("setting pen")
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

func cellForAnswer(_ answerIndex: Int) -> Int? {
    switch answerIndex {
    case 0:
        return 0
    case 1:
        return 2
    case 2:
        return 4
    case 3:
        return 12
    case 4:
        return 14
    case 5:
        return 16
    case 6:
        return 24
    case 7:
        return 26
    case 8:
        return 28
    default:
        return nil
    }
}
