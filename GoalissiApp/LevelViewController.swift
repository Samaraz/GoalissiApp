//
//  LevelViewController.swift
//  GoalissiApp
//
//  Created by MAC on 15/08/2022.
//

import UIKit

class LevelViewController: UIViewController {
    
    var playerSelected : String?

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Level"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        // Do any additional setup after loading the view.
    }
    

}

extension LevelViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCollectionViewCell", for: indexPath) as! LevelCollectionViewCell
        cell.setUp(with: levels[indexPath.row] )
        return cell
    }
    
}

extension LevelViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.view.frame.width/2 , height:self.view.frame.height/4)
    }
}

extension LevelViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(levels[indexPath.row].levelName)
        if let vc = storyboard?.instantiateViewController(withIdentifier:"gameController" ) as? ViewController{
            vc.levelSelected = levels[indexPath.row].levelName
            vc.playerSelected = self.playerSelected
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
