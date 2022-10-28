//
//  DifficultyViewController.swift
//  GoalissiApp
//
//  Created by MAC on 10/08/2022.
//

import UIKit

class DifficultyViewController: UITableViewController {
    
    var playerSelected : String?
    var level = ["Novice","Intermediate","Pro"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Level"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        level.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "level", for: indexPath)
        cell.textLabel?.text = level[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        return cell
    }
    
    //MARK: - Table View Data Manipulation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier:"gameController" ) as? ViewController{
            vc.levelSelected = level[indexPath.row]
            vc.playerSelected = self.playerSelected
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}
