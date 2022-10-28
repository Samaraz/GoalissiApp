//
//  WelcomeViewController.swift
//  GoalissiApp
//
//  Created by MAC on 10/08/2022.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet var welcomeLabel: CLTypingLabel!
    @IBOutlet weak var goalisiAppLabel: CLTypingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.backgroundColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        button1.layer.cornerRadius = 25
        //button1.layer.borderWidth = 1
//        button2.layer.borderColor = UIColor.black.cgColor
        button2.backgroundColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        button2.layer.cornerRadius = 25
       // button2.layer.borderWidth = 2
        
        //button2.layer.borderColor = #colorLiteral(red: 0.2373020085, green: 1, blue: 0.795570053, alpha: 1)
       
        
        goalisiAppLabel.text = "GoalissiApp⚽"

    }

}
