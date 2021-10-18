//
//  FriendController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/18.
//

import UIKit
import FirebaseAuth
import Firebase

class FriendController:UIViewController {
    var friendName:[String] = []
    
    @IBOutlet var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        db.collection("users")
            .document(auth.currentUser!.uid)
            .collection("friends")
            .getDocuments(completion: {(documents, error) in
                if let error = error {
                    print("ユーザーエラー発生：\(error)")
                } else {
                    for document in documents!.documents {
                        self.friendName.append(document.value(forKey: "uid") as! String)
                    }
                }
            })
        
        tableView.reloadData()
    }
    
    
}

extension FriendController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
