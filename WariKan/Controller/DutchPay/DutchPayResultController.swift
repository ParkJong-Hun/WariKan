//
//  DutchPayResultController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/30.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DutchPayResultController:UIViewController {
    var items:[Item] = []
    var seperates:[Seperate] = []
    var wariSwitch:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var textI = ""
        var textS = ""
        var textR = ""
        let tot = items.map{$0.itemCost}.reduce(0, {$0 + $1})
        for item in items {
            textI += "\(item.itemTitle) : \(item.itemCost)円\n"
        }
        for seperate in seperates {
            if wariSwitch {
                let resultMoney = Double(tot) * (Double(seperate.money) / Double(100))
                textS += "\(seperate.name) : \(resultMoney)円 (\(seperate.money))%\n"
            } else {
                textS += "\(seperate.name) : \(seperate.money)円\n"
            }
        }
        textR = "合計 : \(tot)\n"
        itemResult.text = textI
        seperateResult.text = textS
        result.text = textR
    }
    
    @IBOutlet weak var itemResult: UILabel!
    @IBOutlet weak var seperateResult: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBAction func clickedOkButton(_ sender: Any) {
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        var data:[String:Any] = [:]
        let tot = items.map{$0.itemCost}.reduce(0, {$0 + $1})
        let uuid = UUID().uuidString
        
        for item in items {
            data[item.itemTitle] = item.itemCost
        }
        data["WariKanSumItems"] = tot
        data["WariKanBuyer"] = auth.currentUser?.uid
        data["WariKanDate"] = Date()
        db.collection("payLists")
            .document(uuid)
            .setData(data) { (error) in
            print("勘定目録エラー発生：\(error.debugDescription)")
        }

        for seperate in seperates {
            if wariSwitch {
                let resultMoney = Double(tot) * (Double(seperate.money) / Double(100))
                db.collection("payLists")
                    .document(uuid)
                    .collection("payers")
                    .document(seperate.name)
                    .setData([seperate.name:resultMoney])
            } else {
                db.collection("payLists")
                    .document(uuid)
                    .collection("payers")
                    .document(seperate.name)
                    .setData([seperate.name:seperate.money])
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
