//
//  ResultViewController.swift
//  GoalissiApp
//
//  Created by MAC on 12/08/2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    var scoreFinal : Double?
    var numberOfQuestionsAnsweredFinal:Int?
    var numberOfCorrectAnswersFinal:Int?
    
    @IBOutlet weak var finalScore: UILabel!
    @IBOutlet weak var questionAnswered: UILabel!
    @IBOutlet weak var correctAnswers: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        finalScore.text = "Your Final Score is \(scoreFinal!)"
        questionAnswered.text = "You answered \(numberOfQuestionsAnsweredFinal!) question(s) "
        correctAnswers.text = "You got \(numberOfCorrectAnswersFinal!) question(s) correctly"
        
       
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTaped(_ sender: UIButton) {
        if sender.tag == 0{
            if let db = storyboard?.instantiateViewController(withIdentifier: "users") as? UsersTableViewController{
                navigationController?.pushViewController(db, animated: true)
            }
        } else {
            if let bb = storyboard?.instantiateViewController(withIdentifier: "leaders") as? LeadersViewController{
                navigationController?.pushViewController(bb, animated: true)
            }
        }
        
    }
}
