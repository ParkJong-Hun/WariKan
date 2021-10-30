//
//  MainController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/17.
//

import UIKit
import Firebase
import FirebaseAuth

//OK

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
    override func viewWillAppear(_ animated: Bool) {
        let auth = Auth.auth()
        guard let email:String = auth.currentUser?.email else { return }
        currentLogin.text = "現在ログイン：" + email
    }
    
    let buttonCollectionCellList = ["割り勘", "奢り"]
    let buttonTableCellList = ["友達", "勘定目録", "ログアウト"]
    
    @IBOutlet weak var buttonCollection: UICollectionView!
    @IBOutlet weak var buttonTable: UITableView!
    @IBOutlet weak var currentLogin: UILabel!
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
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "FriendController") as? FriendController {
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
        // 勘定目録
        if buttonTableCellList[indexPath.row] == "勘定目録" {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "PayListController") as? PayListController {
                self.navigationController?.pushViewController(controller, animated: true)
            }
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
        let cell = buttonCollection.dequeueReusableCell(withReuseIdentifier: "Warikan", for: indexPath) as! ButtonCollectionCell
        cell.button.setTitle(buttonCollectionCellList[indexPath.row], for: .normal)
        // TODO: テクストサイズ
        cell.layer.cornerRadius = 5;
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller:UIViewController
        if buttonCollectionCellList[indexPath.row] == "割り勘" {
            controller = storyboard?.instantiateViewController(withIdentifier: "DutchPayController") as! DutchPayController
        } else {
            controller = storyboard?.instantiateViewController(withIdentifier: "GraceController") as! GraceController
        }
        self.navigationController?.pushViewController(controller, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
