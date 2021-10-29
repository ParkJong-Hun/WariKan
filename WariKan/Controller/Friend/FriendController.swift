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
    var followerName = Set<String>()
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var tableViewFollow: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewFollow.delegate = self
        tableViewFollow.dataSource = self
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
                        }
                        self.tableView.reloadData()
                    }
                })
            db.collection("users")
                .getDocuments(completion: {(documents, error) in
                    if let error = error {
                        print("ユーザーエラー発生：\(error)")
                    } else {
                        for document in documents!.documents {
                            db.collection("users")
                                .document(document["uid"] as! String)
                                .collection("friend")
                                .whereField("uid", in: [auth.currentUser!.uid])
                                .getDocuments(completion: {(documents, error) in
                                    for _ in documents!.documents {
                                        self.followerName.update(with: document["uid"] as! String)
                                    }
                                    self.tableViewFollow.reloadData()
                                })
                        }
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
        if tableView == self.tableView {
            return friendName.count
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {// フォロー
            let cell = UITableViewCell()
            let index = friendName.index(friendName.startIndex, offsetBy: indexPath.row)
            cell.textLabel?.text = friendName[index]
            return cell
        } else {//　フォローワー
            let cell = UITableViewCell()
            
            var list:String = ""
            if followerName.count > 3 {
                for i in 0..<3 {
                    let index = followerName.index(followerName.startIndex, offsetBy: i)
                    list += followerName[index] + ", "
                }
                list.removeLast()
            } else if followerName.count > 0 {
                for i in followerName {
                    list += i + ", "
                }
                list.removeLast()
            } else {
                list = "フォローワーがいません。"
            }
            cell.detailTextLabel?.text = String(followerName.count)
            cell.textLabel?.text = list
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            //何も起こらない
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if followerName.count != 0 {
                let controller = storyboard?.instantiateViewController(withIdentifier: "FollowerController") as! FollowerController
                controller.followerName = [String](followerName)
                present(controller, animated: true, completion: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
