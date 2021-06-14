//
//  AdminViewController.swift
//  GitRepoSearch
//
//  Created by Tabish Sohail on 14/06/2021.
//

import UIKit

class AdminViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noResultLabel: UILabel!
    
    var adminPresenter: AdminViewModel = AdminViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    

    func initialSetup(){
        tableViewSetup()
    }
    
    func setupNavigation(){
        self.title = "Recent Searches"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}


extension AdminViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Tableview methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0

        rowCount = self.adminPresenter.numberOfRows

        if rowCount > 0 {
            self.noResultLabel.isHidden = true
        } else {
            self.noResultLabel.isHidden = false
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        if adminPresenter.numberOfRows > indexPath.row{
            
            let str = Array(GlobalService.shared.searchHistory.keys)[indexPath.row]
            cell!.textLabel?.text = str
            let count = adminPresenter.getResultsForText(text: str).count
            
            
            cell?.detailTextLabel?.text = "\(count == 0 ? 0:count) results"
            cell?.accessoryType = count > 0 ? .disclosureIndicator:.none

        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let cellModel = adminPresenter.getRepoDataModel(index: indexPath.row)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: SearchResultsDetailViewController.identifier) as? SearchResultsDetailViewController {
                vc.model = cellModel
                self.navigationController?.pushViewController(vc, animated: true)
            
        }
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
