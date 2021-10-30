//
//  FollowerController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/27.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

//OK

class FollowerController:UIViewController {
    
    var followerName:[String] = []
    
    @IBOutlet var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FollowerController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        followerName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = followerName[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: フォローワーリスト（お互いフォローできるような機能）移動
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
