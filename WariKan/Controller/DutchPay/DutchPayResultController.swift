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
    }
    
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
        db.collection("payLists")
            .document(uuid)
            .setData(data) { (error) in
            print("勘定目録エラー発生：\(error.debugDescription)")
        }
        //TODO: 返す金額の部分
        /*for seperate in seperates {
            if wariSwitch {
                db.collection("payLists")
                    .document(uuid)
                    .collection("payers")
                    .document(seperate.name)
                    .setData(<#T##documentData: [String : Any]##[String : Any]#>)
            } else {
                db.collection("payLists")
                    .document(uuid)
                    .collection("payers")
                    .document(seperate.name)
                    .setData(<#T##documentData: [String : Any]##[String : Any]#>)
            }
        }*/
    }
}
