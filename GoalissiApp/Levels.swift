//
//  Levels.swift
//  GoalissiApp
//
//  Created by MAC on 15/08/2022.
//

import Foundation
import UIKit

struct Levels {
    let levelName:String
    let image:UIImage
    let color:UIColor
}

let levels : [Levels] = [
    Levels(levelName: "Novice", image:UIImage(systemName: "location.north")!, color: .gray),
    Levels(levelName: "Intermediate", image:UIImage(systemName: "airplane.departure")!, color: .yellow),
    Levels(levelName: "Pro", image:UIImage(systemName: "checkmark.seal")!, color: .green)
    ]
