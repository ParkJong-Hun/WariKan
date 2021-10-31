//
//  DutchPaySeperateController.swift
//  WariKan
//
//  Created by 박종훈 on 2021/10/30.
//

import UIKit

class DutchPaySeperateController: UIViewController {
    var items:[Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func clickedAddButton(_ sender: Any) {
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
        items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
