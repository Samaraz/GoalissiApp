//
//  UsersTableViewController.swift
//  GoalissiApp
//
//  Created by MAC on 10/08/2022.
//

import UIKit
import CoreData
import SwipeCellKit

class UsersTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var playersList = [Player]()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        loadPlayers()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        title = "Select Player"
      
        
    }
    
    @IBAction func addUserPressed(_ sender: UIBarButtonItem) {
        if playersList.count < 6{
            promptNewUser()
        }else{
            let vc = UIAlertController(title: "Maximum number of Players reached", message: "Swipe to delete an existing Player Profile ", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(vc, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
     func promptNewUser(){
         
        var textField = UITextField()
        let vc = UIAlertController(title: "Add New Player", message: "Type Player Name inside the Box below", preferredStyle: .alert)
         
         vc.addTextField { alertTextField in
             alertTextField.placeholder = "Create New Player"
             textField = alertTextField
         }
         
         vc.addAction(UIAlertAction(title: "Add Player", style: .default, handler: { actionAdd in
             if textField.text!.count >= 4{
                 let newPlayer = Player(context: self.context) // staging newPlayer to the context
                 newPlayer.name = textField.text!
                 
                 self.playersList.append(newPlayer)
                 self.savePlayer()
             }else{
                 let vc = UIAlertController(title: "Player name must contain at least four(4) characters", message: nil,preferredStyle: .alert)
                 vc.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                 self.present(vc, animated: true, completion: nil)
             }
             
             
         }))
         present(vc, animated: true, completion: nil)
    }
    
    
    
    func savePlayer(){
        do{
           try context.save() // saves the context to the persistent container
        }catch{
            print("Error saving User \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func loadPlayers(){
        let request :NSFetchRequest<Player> = Player.fetchRequest()
        do{
            playersList = try context.fetch(request)
        }catch{
            print("Error trying to fetch Request \(error)")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playersList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = playersList[indexPath.row].name
        cell.textLabel?.textColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
        
        return cell
    }
    
    //MARK: - Table View Data Manipulation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(playersList[indexPath.row])
//        playersList.remove(at: indexPath.row)
//        savePlayer()
        if let bc = storyboard?.instantiateViewController(withIdentifier: "levelViewController") as? LevelViewController{
            bc.playerSelected = playersList[indexPath.row].name
            navigationController?.pushViewController(bc, animated: true)
        }
    }
}

extension UsersTableViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.swipeToDeleteCell(indexPathDotRow: indexPath.row)
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func swipeToDeleteCell(indexPathDotRow:Int){
        let vc  = UIAlertController(title: "Delete Player", message: "Are you sure you want to Delete this Player?", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Delete", style: .default, handler: { actionDelete in
            self.context.delete(self.playersList[indexPathDotRow])
            self.playersList.remove(at: indexPathDotRow)
            self.savePlayer()
        }))
        vc.addAction(UIAlertAction(title: "Discard", style: .default, handler: { actionDiscard in
            self.tableView.reloadData()
        }))
        
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
    
}
