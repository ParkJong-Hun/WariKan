//
//  MainController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/17.
//

import UIKit
import Firebase
import FirebaseAuth

class MainController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        buttonTable.delegate = self
        buttonTable.dataSource = self
        
        buttonCollection.delegate = self
        buttonCollection.dataSource = self
        
        buttonTable.layer.cornerRadius = 5;
    }
    
    let buttonCollectionCellList = ["割り勘", "奢り"]
    let buttonTableCellList = ["友達", "勘定目録", "ログアウト"]
    
    @IBOutlet weak var buttonCollection: UICollectionView!
    @IBOutlet weak var buttonTable: UITableView!
}

//　テーブルボタンリスト
extension MainController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buttonTableCellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TomodachiCell", for: indexPath)
        cell.textLabel?.text = buttonTableCellList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 友達
        if buttonTableCellList[indexPath.row] == "友達" {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "TomodachiController") as? FriendController {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        // ログアウト
        if buttonTableCellList[indexPath.row] == "ログアウト" {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("ログアウトエラー：\(signOutError)")
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// コレクションボタンリスト
extension MainController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttonCollectionCellList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ButtonCollectionCell = buttonCollection.dequeueReusableCell(withReuseIdentifier: "Warikan", for: indexPath) as! ButtonCollectionCell
        cell.button.titleLabel!.text = buttonCollectionCellList[indexPath.row]
        cell.layer.cornerRadius = 5;
        return cell
    }
}
