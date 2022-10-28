//
//  LevelCollectionViewCell.swift
//  GoalissiApp
//
//  Created by MAC on 15/08/2022.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var difficultyName: UILabel!
    
    func setUp(with level:Levels){
        image.image = level.image
        image.tintColor = level.color
        difficultyName.text = level.levelName
        difficultyName.textColor = level.color
        
    }
}
