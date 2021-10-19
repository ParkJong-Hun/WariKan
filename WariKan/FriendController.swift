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
    var friendName = Set<String>()
    
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
        
        DispatchQueue.global(qos: .userInteractive).sync {
            db.collection("users")
                .document(auth.currentUser!.uid)
                .collection("friends")
                .getDocuments(completion: {(documents, error) in
                    if let error = error {
                        print("ユーザーエラー発生：\(error)")
                    } else {
                        for document in documents!.documents {
                            self.friendName.update(with:document["email"] as! String)
                            print("hi")
                        }
                        self.tableView.reloadData()
                    }
                })
        }
    }
    // 友達追加
    @IBAction func clickedAddButton(_ sender: Any) {
        let db = Firestore.firestore()
        let auth = Auth.auth()

        let alert = UIAlertController(title: "友達追加", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: {_ in
            guard let textField = alert.textFields?.first, let friendEmail = textField.text, !friendEmail.isEmpty else { return }
            
            db.collection("users")
                .whereField("email", in: [friendEmail])
                .getDocuments(completion: {(documents, error) in
                    if let error = error {
                        print("ユーザーエラー発生：\(error)")
                    } else {
                        for document in documents!.documents {
                            var data = [String : Any]()
                            data["email"] = friendEmail
                            data["uid"] = document["uid"]
                            
                            db.collection("users")
                                .document(auth.currentUser!.uid)
                                .collection("friends")
                                .addDocument(data: data)
                            break
                        }
                    }
                })
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension FriendController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let index = friendName.index(friendName.startIndex, offsetBy: indexPath.row)
        cell.textLabel?.text = friendName[index]
        return cell
    }
}
