//
//  SearchResultsDetailViewController.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 15/06/2021.
//

import UIKit

class SearchResultsDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var model: [RepoInfoModel?] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}


extension SearchResultsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Tableview methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = model.count

        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        if model.count > indexPath.row{
            
            cell!.textLabel?.text = model[indexPath.row]?.name ?? ""
            
            
            cell?.detailTextLabel?.text = model[indexPath.row]?.description ?? ""

        }
        return cell!
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            let height:CGFloat = 50
//
//            return height
//        }
    
    
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.reloadData()
    }
}
