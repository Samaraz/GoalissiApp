//
//  LeadersViewController.swift
//  GoalissiApp
//
//  Created by MAC on 12/08/2022.
//

import UIKit
import Charts
import CoreData

class LeadersViewController: UIViewController {
    
    var leadersDelegate : outsideControl?
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var playerPlusScore = [PlayerAndScore]()
    
    var firstPositionPlayer:String = "A"
    var firstPositionScore:Double = 0
    var secondPositionPlayer:String = "B"
    var secondPositionScore:Double = 0
    var thirdPositionPlayer:String = "C"
    var thirdPositionScore:Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopScores()
        createChart()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.leadersDelegate?.playCountDownTimer()
    }
    
    private func createChart(){
        // Create Bar Chart
        let barChart = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2))
        
        // Configure Axis
        let xAxis = barChart.xAxis
        
    
        let rightAxis = barChart.rightAxis
        // Configure Legend
        let legend = barChart.legend
        legend.textColor = .systemGreen
        legend.textWidthMax = 20
        legend.textHeightMax = 10
        // Supply Data
        var entries1 = [BarChartDataEntry]()
        var entries2 = [BarChartDataEntry]()
        var entries3 = [BarChartDataEntry]()
        
        entries1.append(BarChartDataEntry(x: Double(0), y:secondPositionScore))
            entries2.append(BarChartDataEntry(x: Double(1), y: firstPositionScore))
            entries3.append(BarChartDataEntry(x: Double(2), y: thirdPositionScore))
            
       
        
        let set1 = BarChartDataSet(entries: entries1, label: secondPositionPlayer)
        set1.colors = [NSUIColor(cgColor: UIColor.systemGray.cgColor),
                      NSUIColor(cgColor: UIColor.systemGreen.cgColor),
                      NSUIColor(cgColor: UIColor.systemRed.cgColor)
        ]
        
        let set2 = BarChartDataSet(entries: entries2, label:firstPositionPlayer)
        set2.colors = [NSUIColor(cgColor: UIColor.systemGreen.cgColor),
                      NSUIColor(cgColor: UIColor.systemGreen.cgColor),
                      NSUIColor(cgColor: UIColor.systemRed.cgColor)
        ]
        
        let set3 = BarChartDataSet(entries: entries3, label:thirdPositionPlayer)
        set3.colors = [NSUIColor(cgColor: UIColor.systemRed.cgColor),
                      NSUIColor(cgColor: UIColor.systemGreen.cgColor),
                      NSUIColor(cgColor: UIColor.systemRed.cgColor)
        ]
        let data = BarChartData(dataSets: [set1,set2,set3])
        
        barChart.data = data
        
        view.addSubview(barChart)
        barChart.center = view.center
    }
    
    
    func fetchTopScores(){
        let request : NSFetchRequest<PlayerAndScore> = PlayerAndScore.fetchRequest()
        let sort = NSSortDescriptor(key: "playerScore", ascending: false)
        
        request.sortDescriptors = [sort]
        
        do{
            playerPlusScore = try context.fetch(request)
        }catch{
            print("Error trying to fetch Request \(error)")
        }
        
        firstPositionPlayer = (playerPlusScore[0].playerName ?? "A")
        firstPositionScore = (playerPlusScore[0].playerScore)
        secondPositionPlayer = (playerPlusScore[1].playerName ?? "B")
        secondPositionScore = (playerPlusScore[1].playerScore)
        thirdPositionPlayer = (playerPlusScore[2].playerName ?? "C")
        thirdPositionScore = (playerPlusScore[2].playerScore)
        print(playerPlusScore[0].playerName!)
        print(playerPlusScore[0].playerScore)
        print(playerPlusScore[1].playerName!)
        print(playerPlusScore[1].playerScore)
        print(playerPlusScore[2].playerName!)
        print(playerPlusScore[2].playerScore)
    }
}
