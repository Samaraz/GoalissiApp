//
//  ViewController.swift
//  GoalissiApp
//
//  Created by MAC on 03/08/2022.
//

import UIKit
import WebKit
import CoreData


protocol outsideControl {
    func playCountDownTimer()
    func updateUI()
}

class ViewController: UIViewController, outsideControl {
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var playersPlusScore = [PlayerAndScore]()
    var levelSelected:String?
    var playerSelected:String?
    var timeRemaining : Int = 60
    var countDownTimer : Timer!
    var circularProgressBarView: CircularProgressBarView!
    var circularViewDuration: TimeInterval = 60
    var score:Double = 0
    var finalScore:Double = 0
    var footballer = [String]()
    var selectedAnswer : String = ""
    var footballerDisplayedName : String = "sanchoo"
    var timer = Timer()
    var numberOfQuestionsAnswered : Int = 0
    var numberOfCorrectAnswers : Int = 0
    var text:String? = "Hey Friend, Can you help me with this Football player name?"
    
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var playerPlaying: UILabel!
    @IBOutlet weak var countDownTimerLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.backgroundColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        button1.layer.cornerRadius = 25
        //button1.layer.borderWidth = 1
//        button2.layer.borderColor = UIColor.black.cgColor
        button2.backgroundColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        button2.layer.cornerRadius = 25
        
        button3.backgroundColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        button3.layer.cornerRadius = 25
        title = "Score: \(score)"
        playerPlaying.text = playerSelected
        levelLabel.text = levelSelected
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let players =  try! fm.contentsOfDirectory(atPath: path)
        for player in players{
            if player.hasSuffix(".jpeg"){
                let play = ((player as NSString).deletingPathExtension)
                footballer.append(play)
            }
        }
        
        imageView.image = UIImage(named:footballerDisplayedName)
        
        let share = UIBarButtonItem(barButtonSystemItem:.action , target:self , action: #selector(shareTapped))
        
        let info = UIBarButtonItem(image:UIImage(systemName:"info.circle"), style:.plain , target: self, action: #selector(showInfo) )
        
        let leaders = UIBarButtonItem(image:UIImage(systemName:"person.3"), style:.plain , target: self, action: #selector(leadersTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [share,spacer,leaders,spacer,info]
        for item in toolbarItems!{
            item.tintColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        }
        navigationController?.isToolbarHidden = false
        
        setUpCircularProgressBarView()
        countDownTimerLabel.center =  CGPoint(x: view.frame.size.width / 2, y: 130)
        
        resetCountDownTimer()
        askQuestion()
        
        
    }
    
    @objc func showInfo(){
        pauseCountDownTimer()
        let vc = UIAlertController(title: "App Info", message: "The GoalissiApp was created and published by Samaraz Instinct", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { dismissAction in
            self.playCountDownTimer()
        }))
        present(vc, animated: true)
    }
    
    @objc func shareTapped(){
        pauseCountDownTimer()
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else{
            print("No image to share")
            return
        }
        guard let text = text else{
            print("Nothing to share")
            return
        }
        let vc = UIActivityViewController(activityItems: [text,image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        vc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                self.playCountDownTimer()
                print("User Cancel")
                return
            }
            // User completed activity
            print("Completed")
            self.playCountDownTimer()
        }

        present(vc, animated: true)
    }
    
    
    @objc func leadersTapped(){
        pauseCountDownTimer()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "leaders") as? LeadersViewController{
            vc.leadersDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func askQuestion(){
        if timeRemaining > 0 {
            footballer.shuffle()
            button1.setTitle(footballer[0], for: .normal)
            button2.setTitle(footballer[1], for: .normal)
            button3.setTitle(footballer[2], for: .normal)
            let randomNumber = Int.random(in: 0...2)
            imageView.image = UIImage(named:footballer[randomNumber])
            footballerDisplayedName = footballer[randomNumber]
        } else{
            let vc = UIAlertController(title: "Time Up", message: "Your Final score is \(score)", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { action in
                self.viewDidLoad()
                
            }))
            vc.addAction(UIAlertAction(title: "View Detailed Results", style: .default, handler: { action2 in
                self.postFinalResults()
            }))
            
            vc.addAction(UIAlertAction(title: "Exit Game", style: .destructive,handler: { action3 in
                exit(0)
            }))
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        selectedAnswer = sender.currentTitle!
        numberOfQuestionsAnswered += 1
        
        if selectedAnswer == footballerDisplayedName{
            addScore()
            numberOfCorrectAnswers += 1
            title = "Score: \(score)"
            sender.backgroundColor = #colorLiteral(red: 0.08458700031, green: 0.2118197978, blue: 0.22896263, alpha: 1)
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        } else {
            sender.backgroundColor = UIColor.red
            
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(missedAnswer), userInfo: nil, repeats: false)
        }
        
        
    }
    
    @objc func updateUI(){
        button1.backgroundColor = UIColor.clear
        button2.backgroundColor = UIColor.clear
        button3.backgroundColor = UIColor.clear
        askQuestion()
    }
    // Do any additional setup after loading the view.
    
    @objc func missedAnswer(){
        pauseCountDownTimer()
        let ac = UIAlertController(title: "That was \(footballerDisplayedName)", message: "The answer you chose was wrong 🛑", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue Anyway", style: .default, handler: { action1 in
            self.playCountDownTimer()
            self.updateUI()
        }))
        
        ac.addAction(UIAlertAction(title: "Check Player Bio", style: .default, handler: { action2 in
            
            if let bc = self.storyboard?.instantiateViewController(withIdentifier: "browser") as? BrowserViewController{
                bc.playerToSearch = self.footballerDisplayedName
                bc.delegate = self
                bc.update = self
                self.navigationController?.pushViewController(bc, animated: true)
            }
            
        }))
        present(ac, animated: true, completion: nil)
        
    }
    
    func setUpCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        // align to the center of the screen
        circularProgressBarView.center = CGPoint(x: view.frame.size.width / 2, y: 130)
        // call the animation with circularViewDurationCannot assign value of type 'NSLayoutYAxisAnchor' to type '
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
        // add this view to the view controller
        view.addSubview(circularProgressBarView)
        
    }
    
    func playCountDownTimer(){
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func pauseCountDownTimer(){
        countDownTimer.invalidate()
        
        
    }
    
    func resetCountDownTimer(){
        timeRemaining = 60
        playCountDownTimer()
    }
    
    @objc func countDown(){
        if timeRemaining > 0{
            timeRemaining -= 1
            countDownTimerLabel.text = "\(timeRemaining)"
        } else{
            
            countDownTimer.invalidate()
            countDownTimerLabel.text = "\(timeRemaining)"
            askQuestion()
            endOfGame()
        }
    }
    
    func addScore(){
        if levelSelected == "Novice"{
            score += 1
        } else if levelSelected == "Intermediate"{
            score += 1.5
        } else{
            score += 2.0
        }
    }
    
    func resetScore(){
        score = 0
    }
    
    func endOfGame(){
        
        let newRecord = PlayerAndScore(context: context)
        newRecord.playerName = playerSelected
        newRecord.playerScore = score
        playersPlusScore.append(newRecord)
        savePlayerAndScore()
        finalScore = score
        resetScore()
    }
    
    func savePlayerAndScore(){
        do{
            try context.save() // saves the context to the persistent container
        }catch{
            print("Error saving User \(error)")
        }
        
    }
    
    func fetchTopScores(){
        let request : NSFetchRequest<PlayerAndScore> = PlayerAndScore.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PlayerAndScore.playerScore), ascending: false)
        
        request.sortDescriptors = [sort]
        
        do{
            playersPlusScore = try context.fetch(request)
        }catch{
            print("Error trying to fetch Request \(error)")
        }
        
    }
    
    func postFinalResults(){
        if let cc = self.storyboard?.instantiateViewController(withIdentifier: "results") as? ResultViewController{
            cc.scoreFinal = self.finalScore
            cc.numberOfQuestionsAnsweredFinal = self.numberOfQuestionsAnswered
            cc.numberOfCorrectAnswersFinal = self.numberOfCorrectAnswers
            navigationController?.pushViewController(cc, animated: true)
            
        }
    }
    
}
    
    
    
    
