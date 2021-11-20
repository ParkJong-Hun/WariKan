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
    var seperates:[Seperate] = []
    var wariSwitch:Bool = false
    
    @IBOutlet weak var totReminderLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBAction func clickedSwitch(_ sender: UISwitch) {
        modeLabel.text = sender.isOn ? "パーセントモード" : "金額モード"
        wariSwitch = !wariSwitch
        
        let tot = self.items.map({$0.itemCost}).reduce(0, {$0 + $1})
        let rem = self.seperates.map({$0.money}).reduce(0, {$0 + $1})
        if self.wariSwitch {
            self.totReminderLabel.text = "合計: 100% (\(tot)円)\n"
            self.totReminderLabel.text! += "残り: \(100 - rem)%"
        } else {
            self.totReminderLabel.text = "合計: \(tot)円\n"
            self.totReminderLabel.text! += "残り: \(tot - rem)円"
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBAction func clickedAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "人を追加", message: "分割する人と金額や割を記入してください。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "友達の名前検索", style: .default, handler: {_ in
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DutchPaySelectFriendController") {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "金額や割(%を入れると割）"
        })
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: {_ in
            if let selectedFriend = UserDefaults.standard.string(forKey: "dutchPaySelectedFriend") {
                UserDefaults.standard.removeObject(forKey: "dutchPaySelectedFriend")
                let money = alert.textFields?.last?.text
                if let money = money {
                    let seperate = Seperate()
                    seperate.name = selectedFriend
                    seperate.money = Int(money) ?? 0
                    self.seperates.append(seperate)
                }
                let tot = self.items.map({$0.itemCost}).reduce(0, {$0 + $1})
                let rem = self.seperates.map({$0.money}).reduce(0, {$0 + $1})
                if self.wariSwitch {
                    self.totReminderLabel.text = "合計: 100% (\(tot)円)\n"
                    self.totReminderLabel.text! += "残り: \(100 - rem)%"
                } else {
                    self.totReminderLabel.text = "合計: \(tot)円\n"
                    self.totReminderLabel.text! += "残り: \(tot - rem)円"
                }
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func clickedOkButton(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "DutchPayResultController") as! DutchPayResultController
        controller.items = items
        controller.seperates = seperates
        controller.wariSwitch = wariSwitch
        if (wariSwitch && seperates.map({$0.money}).reduce(0, {$0 + $1}) == 100) || (!wariSwitch && seperates.map({$0.money}).reduce(0, {$0 + $1}) == items.map({$0.itemCost}).reduce(0, {$0 + $1})) {
            navigationController?.pushViewController(controller, animated: true)
        } else {
            //数値異常
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tot = self.items.map({$0.itemCost}).reduce(0, {$0 + $1})
        
        modeLabel.text = "金額モード"
        totReminderLabel.text = "合計: \(tot)円\n"
        totReminderLabel.text! += "残り: \(tot)円"
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension DutchPaySeperateController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seperates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeperateCell") as! SeperateCell
        cell.textLabel?.text = seperates[indexPath.row].name
        cell.money.text = String(seperates[indexPath.row].money)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
