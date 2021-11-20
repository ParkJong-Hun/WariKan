//
//  DutchPaySelectFriendController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/11/07.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DutchPaySelectFriendController:UIViewController {
    var friendName = [String]()
    var selectedFriend = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        db.collection("users").document(auth.currentUser!.uid).collection("friends")
            .getDocuments(completion: { (documents,error) in
                for document in documents!.documents {
                    self.friendName.append(document["email"] as! String)
                }
            })
        self.tableView.reloadData()
    }
    
    @IBAction func clickedAddButton(_ sender: Any) {
        if !selectedFriend.isEmpty {
            UserDefaults.standard.set(selectedFriend, forKey: "dutchPaySelectedFriend")
            navigationController?.popViewController(animated: true)
        }
    }
    @IBOutlet weak var tableView: UITableView!
}

extension DutchPaySelectFriendController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = friendName[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .green
        selectedFriend = friendName[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .none
    }
}
