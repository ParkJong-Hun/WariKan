//
//  DutchPayController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/28.
//

import UIKit

// 割り勘

class DutchPayController:UIViewController {
    var items:[Item] = []
    var tot = 0
    
    @IBOutlet weak var TotLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func clickedOkButton(_ sender: Any) {//　勘定目録に保存
        let controller = storyboard?.instantiateViewController(withIdentifier: "DutchPaySeperateController") as! DutchPaySeperateController
        controller.items = items
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickedAddButton(_ sender: Any) {// 買った物を追加する
        let alert = UIAlertController(title: "物を追加", message: "タイトルと価格を入力してください", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "タイトル"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "価格"
        })
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: { [self]_ in
            let titleName:String = (alert.textFields?.first?.text)!
            let costString:String = (alert.textFields?.last?.text)!
            
            if Int(costString) != nil && titleName != "" {
                let item = Item()
                item.itemTitle = titleName
                item.itemCost = Int(costString)!
                
                tot += Int(costString)!
                TotLabel.text = String(tot)
                self.items.append(item)
            }
            tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension DutchPayController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.textLabel?.text = items[indexPath.row].itemTitle
        cell.cost.text = "\(items[indexPath.row].itemCost)円"
        return cell
    }
    
    
}
