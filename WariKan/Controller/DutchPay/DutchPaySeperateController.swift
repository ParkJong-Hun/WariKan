//
//  DutchPaySeperateController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/30.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

//　割り勘分割

class DutchPaySeperateController: UIViewController {
    var items:[Item] = []
    var names:[String] = []
    var moneys:[Int] = []
    var wariSwitch:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func clickedAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "人を追加", message: "分割する人と金額や割を記入してください。", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "名前"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "金額や割(%を入れると割）"
        })
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: { [self]_ in
            let name = alert.textFields?.first?.text
            let money = alert.textFields?.last?.text
            if let name = name, let money = money {
                names.append(name)
                moneys.append(Int(money) ?? 0)
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
    }
    @IBAction func clickedOkButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension DutchPaySeperateController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
